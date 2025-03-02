class SettleReceivablesWorker < BaseWorker
  def perform
    # # Too fast but no auditable
    # sql = <<~SQL
    #   UPDATE receivables
    #   SET status = 'liquidado',
    #       liquidation_date = current_date,
    #       amount_settled = amount_to_settle
    #   WHERE status = 'pendente'
    #     AND schedule_date = current_date
    # SQL
    # ActiveRecord::Base.connection.execute(sql)


    # fast and auditable
    # receivables = Receivable.where(status: Receivable::STATUS_PENDING,
    #                                schedule_date: Date.today)
    # receivables.find_each do |receivable|
    #   receivable.update!(
    #     status: Receivable::STATUS_LIQUIDATED,
    #     liquidation_date: Date.today,
    #     amount_settled: receivable.amount_to_settle
    #   )
    # end

    # # maintainable, extensible, testable, reusable
    Receivables::SettleAllToday.call
  end
end
