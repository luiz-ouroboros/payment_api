class Receivables::CreateByPaymentTransaction < UseCase
  attributes :payment_transaction

  def call!
    receivables = []

    ActiveRecord::Base.transaction {
      payment_transaction.installments.times do |installment_number|
        receivables << payment_transaction.receivables.create!(
          installment_number: installment_number + 1,
          schedule_date: payment_transaction.created_at + installment_number.months,
          status: Receivable::STATUS_PENDING,
          amount_to_settle: payment_transaction.amount / payment_transaction.installments,
          amount_settled: 0.0,
        )
      end
    }

    Success(
      :create_by_payment_transaction_success,
      result: {
        receivables: receivables,
        payment_transaction: payment_transaction.reload
      }
    )
  end
end
