FactoryBot.define do
  factory :transaction do
    amount { Faker::Number.decimal(l_digits: 2) }
    installment { 12 }
    payment_method { Transaction::PAYMENT_METHODS.sample }
    status { Transaction::STATUS_SENDING }
    gateway { ::Gateways::LIST.sample }
  end
end
