class Gateways::FakeGateway::CreationValidation < UseCase
  attributes :payment_transaction

  def call!
    return Success(:creation_validation_success) if payment_transaction.installments.even?

    Failure(
      :validation_error,
      result: build_error(:installments, 'errors.gateways.fake_gateway.installments_odd')
    )
  end
end
