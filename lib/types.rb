module Types
  include Dry.Types()

  module Transactions
    Amount = Types::Coercible::Decimal.constrained(gt: 0)
    Installment = Types::Coercible::Integer.constrained(gteq: 1, lteq: 12)
    PaymentMethod = Types::Coercible::String.enum(*::Transaction::PAYMENT_METHODS)
  end
end
