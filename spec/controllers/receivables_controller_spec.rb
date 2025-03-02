require 'rails_helper'

RSpec.describe ReceivablesController, type: :controller do
  let(:receivable) { create(:receivable) }
  let(:payment_transaction) { receivable.payment_transaction }
  let(:receivable_pattern) {
    {
      id: Integer,
      payment_transaction_id: Integer,
      installment_number: Integer,
      schedule_date: ::Types::I18nDate,
      liquidation_date: nil,
      status: ::Types::Receivables::Status,
      pending_at: nil,
      settled_at: nil,
      amount_to_settle: ::Types::FloatAsString,
      amount_settled: ::Types::FloatAsString,
      created_at: ::Types::I18nDateTime,
      updated_at: ::Types::I18nDateTime,
    }
  }

  describe 'GET #index' do
    let(:pattern) do
      { data: [receivable_pattern] }
    end

    it 'without filters' do
      receivable_pattern[:id] = receivable.id
      receivable_pattern[:payment_transaction_id] = receivable.payment_transaction_id

      get :index

      expect(response.body).to be_json_as(pattern)
      expect(response).to have_http_status(:ok)
    end

    it 'with filter by payment transaction approved' do
      receivable_sending = create(:receivable)
      receivable_sending.payment_transaction.sending!

      receivable_approved = create(:receivable)
      receivable_approved.payment_transaction.approved!

      receivable_reproved = create(:receivable)
      receivable_reproved.payment_transaction.reproved!

      receivable_sending_error = create(:receivable)
      receivable_sending_error.payment_transaction.sending_error!

      receivable_pattern[:id] = receivable_approved.id
      receivable_pattern[:payment_transaction_id] = receivable_approved.payment_transaction_id

      get :index, params: {
        payment_transaction_status: receivable_approved.payment_transaction.status
      }

      expect(response.body).to be_json_as(pattern)
      expect(response).to have_http_status(:ok)
    end
  end
end
