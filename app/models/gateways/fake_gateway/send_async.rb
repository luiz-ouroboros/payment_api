class Gateways::FakeGateway::SendAsync < UseCase
  attributes :transaction

  def call!
    jid = Gateways::FakeGateway::SendWorker.perform_async(transaction.id)

    Success(:send_async_success, result: { jid: jid })
  end
end
