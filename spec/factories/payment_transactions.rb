FactoryBot.define do
  factory :payment_transaction do
    amount { Faker::Number.decimal(l_digits: 2) }
    installment { 12 }
    payment_method { PaymentTransaction::PAYMENT_METHODS.sample }
    status { PaymentTransaction::STATUS_SENDING }
    gateway { ::Gateways::LIST.sample }
  end
end
