class Gateways::FakeGateway::Send < UseCase
  attributes :payment_transaction

  def call!
    call_gateway_api_client
      .then(apply(:create_receivable))
      .then(apply(:output))
  end

  private

  def call_gateway_api_client
    if payment_transaction.installment.even?
      payment_transaction.approved!
      Success(:call_gateway_api_client_success, result: { payment_transaction: payment_transaction })
    else
      payment_transaction.reproved!
      Failure(
        :validation_error,
        result: build_error(:installment, 'errors.gateways.fake_gateway.installment_odd')
      )
    end
  end

  def create_receivable(**)
    call(Receivables::CreateByPaymentTransaction, payment_transaction: payment_transaction)
  end

  def output(payment_transaction:, **)
    Success(:create_success, result: { payment_transaction: payment_transaction })
  end
end
