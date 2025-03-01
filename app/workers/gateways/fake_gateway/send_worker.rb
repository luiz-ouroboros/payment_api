
module Gateways::FakeGateway
  class SendWorker < BaseWorker
    def perform(id)
      payment_transaction = PaymentTransaction.find(id)
      use_case = ::Gateways.dig(payment_transaction.gateway, :send)

      use_case.call(payment_transaction: payment_transaction)
    end
  end
end
