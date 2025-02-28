module Types
  include Dry.Types()

  I18nDateTime = Types::String.constrained(format: I18n.t('regexp.datetime'))

  module Transactions
    Amount = Types::Coercible::Decimal.constrained(gt: 0)
    Installment = Types::Coercible::Integer.constrained(gteq: 1, lteq: 12)
    PaymentMethod = Types::Coercible::String.enum(*::Transaction::PAYMENT_METHODS)
    Status = Types::Coercible::String.enum(*::Transaction::STATUSES)
    Gateway = Types::Coercible::String.enum(*::Transactions::Gateways::LIST.map(&:to_s))
  end
end
