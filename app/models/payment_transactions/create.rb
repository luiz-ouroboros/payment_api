class PaymentTransactions::Create < UseCase
  attributes :params

  class UseContract < ContractScheme
    params do
      required(:amount).filled(::Types::PaymentTransactions::Amount)
      required(:installments).filled(::Types::PaymentTransactions::Installment)
      required(:payment_method).filled(::Types::PaymentTransactions::PaymentMethod)
    end
  end

  def call!
    transaction {
      validate_params(UseContract, params)
      .then(apply(:build_payment_transaction))
      .then(apply(:validation_by_gateway))
      .then(apply(:save_payment_transaction))
    }.then(apply(:send_to_gateway_async))
      .then(apply(:output))
  end

  private

  def build_payment_transaction(params:, **)
    payment_transaction = PaymentTransaction.new(
      **params,
      status: PaymentTransaction::STATUS_SENDING,
      gateway: ENV['DEFAULT_GATEWAY'],
    )

    Success(:build_payment_transaction_success, result: { payment_transaction: payment_transaction })
  end

  def validation_by_gateway(payment_transaction:, **)
    use_case = ::Gateways.dig(payment_transaction.gateway, :creation_validation)
    call(use_case, payment_transaction: payment_transaction)
  end

  def save_payment_transaction(payment_transaction:, **)
    payment_transaction.save!

    Success(:save_payment_transaction_success, result: { payment_transaction: payment_transaction })
  end

  # def create_installments(payment_transaction:, **)
  #   call(Receivables::CreateByPaymentTransaction, payment_transaction: payment_transaction)
  # end

  def send_to_gateway_async(payment_transaction:, **)
    use_case = ::Gateways.dig(payment_transaction.gateway, :send_async)
    call(use_case, payment_transaction: payment_transaction)
  end

  def output(payment_transaction:, **)
    Success(:create_success, result: { payment_transaction: payment_transaction })
  end
end
