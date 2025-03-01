class Gateways::FakeGateway::CreationValidation < UseCase
  attributes :transaction

  def call!
    return Success(:creation_validation_success) if transaction.installment.even?

    Failure(
      :validation_error,
      result: build_error(:installment, 'errors.gateways.fake_gateway.installment_odd')
    )
  end
end
