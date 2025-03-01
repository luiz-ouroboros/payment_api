class Transactions::Create < UseCase
  attributes :params

  class UseContract < ContractScheme
    params do
      required(:amount).filled(::Types::Transactions::Amount)
      required(:installment).filled(::Types::Transactions::Installment)
      required(:payment_method).filled(::Types::Transactions::PaymentMethod)
    end
  end

  def call!
    transaction {
      validate_params(UseContract, params)
      .then(:build_transaction)
      .then(:validation_by_gateway)
      .then(apply(:save_transaction))
    }.then(:send_to_gateway_async)
      .then(apply(:output))
  end

  private

  def build_transaction(params:, **)
    transaction = Transaction.new(
      **params,
      status: Transaction::STATUS_SENDING,
      gateway: ENV['DEFAULT_GATEWAY'],
    )

    Success(:build_transaction_success, result: { transaction: transaction })
  end

  def validation_by_gateway(transaction:, **)
    use_case = ::Gateways.dig(transaction.gateway, :creation_validation)
    call(use_case, transaction: transaction)
  end

  def save_transaction(transaction:, **)
    transaction.save!

    Success(:save_transaction_success, result: { transaction: transaction })
  end

  def send_to_gateway_async(transaction:, **)
    use_case = ::Gateways.dig(transaction.gateway, :send_async)
    call(use_case, transaction: transaction)
  end

  def output(transaction:, **)
    Success(:create_success, result: { transaction: transaction })
  end
end
