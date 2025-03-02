module Types
  include Dry.Types()

  I18nDateTime = Types::String.constrained(format: I18n.t('regexp.datetime'))
  I18nDate = Types::String.constrained(format: I18n.t('regexp.date'))
  Gateway = Types::Coercible::String.enum(*::Gateways::LIST.map(&:to_s))
  PerPage = Types::Coercible::Integer.constrained(gteq: 1, lteq: 250)
  FloatAsString = Types::Coercible::Float.constrained(gteq: 0).constructor(&:to_s)
  module PaymentTransactions
    Amount = Types::Coercible::Float.constrained(gt: 0)
    Installment = Types::Coercible::Integer.constrained(gteq: 1, lteq: 12)
    PaymentMethod = Types::Coercible::String.enum(*::PaymentTransaction::PAYMENT_METHODS)
    Status = Types::Coercible::String.enum(*::PaymentTransaction::STATUSES)
  end

  module Receivables
    Status = Types::Coercible::String.enum(*::Receivable::STATUSES)
  end
end
