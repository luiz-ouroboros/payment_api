FactoryBot.define do
  factory :receivable do
    payment_transaction { create(:payment_transaction) }
    installment_number { 1 }
    schedule_date { Time.zone.today }
    status { Receivable::STATUS_PENDING }
    amount_to_settle { payment_transaction.amount / payment_transaction.installments }
  end
end
