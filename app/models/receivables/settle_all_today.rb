class Receivables::SettleAllToday < UseCase
  def call!
    receivables = Receivable.where(status: Receivable::STATUS_PENDING,
                                   schedule_date: Date.today)
    receivables.find_each do |receivable|
      receivable.update!(
        status: Receivable::STATUS_SETTLED,
        liquidation_date: Date.today,
        amount_settled: receivable.amount_to_settle
      )
    end

    Success(:settled_all_receivables)
  end
end
