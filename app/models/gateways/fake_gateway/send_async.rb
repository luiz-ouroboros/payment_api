class Gateways::FakeGateway::SendAsync < UseCase
  attributes :payment_transaction

  def call!
    jid = Gateways::FakeGateway::SendWorker.perform_async(payment_transaction.id)

    Success(:send_async_success, result: { jid: jid })
  end
end
