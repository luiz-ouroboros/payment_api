FactoryBot.define do
  factory :installment_fee do
    fee_percentage { 0.99 }
    installments { 1 }
    gateway { ::Gateways::LIST.sample }
  end
end
