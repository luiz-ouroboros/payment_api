require 'rails_helper'

RSpec.describe Receivables::SettleAllToday do
  context 'successfull' do
    it 'settles only the receivables scheduled for today' do
      receivable_today = create(:receivable,
                                schedule_date: Date.current,
                                status: Receivable::STATUS_PENDING)

      receivable_future = create(:receivable,
                                 schedule_date: Date.current + 1.day,
                                 status: Receivable::STATUS_PENDING)

      result =  Receivables::SettleAllToday.call

      receivable_today.reload
      receivable_future.reload

      expect(receivable_today.status).to eq(Receivable::STATUS_SETTLED)
      expect(receivable_today.liquidation_date).to eq(Date.current)
      expect(receivable_today.amount_settled).to eq(receivable_today.amount_to_settle)

      expect(receivable_future.status).to eq(Receivable::STATUS_PENDING)
      expect(receivable_future.liquidation_date).to be_nil
      expect(receivable_future.amount_settled).to eq(0)
    end
  end
end
