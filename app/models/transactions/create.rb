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
        .then(:create_transaction)
    }.then(:output)
  end

  private

  def create_transaction(params:, **)
    transaction = Transaction.create!(
      **params,
      status: Transaction::STATUS_SENDING,
      gateway: ENV['DEFAULT_GATEWAY'],
    )

    Success(:create_transaction_success, result: { transaction: transaction })
  end

  def output(transaction:, **)
    Success(:create_success, result: { transaction: transaction })
  end
end
