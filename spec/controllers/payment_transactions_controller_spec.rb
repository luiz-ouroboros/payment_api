require 'rails_helper'

RSpec.describe PaymentTransactionsController, type: :controller do
  let(:payment_transaction) { create(:payment_transaction) }
  let(:valid_attributes) { attributes_for(:payment_transaction) }
  let(:payment_transaction_pattern) {
    {
      id: Integer,
      amount: ::Types::PaymentTransactions::Amount,
      installments: ::Types::PaymentTransactions::Installment,
      payment_method: ::Types::PaymentTransactions::PaymentMethod,
      status: ::Types::PaymentTransactions::Status,
      approved_at: nil,
      reproved_at: nil,
      gateway: ::Types::Gateway,
      created_at: ::Types::I18nDateTime,
      updated_at: ::Types::I18nDateTime,
    }
  }

  describe 'GET #index' do
    context 'when no date filters are provided' do
      it 'return the payment transaction on the end of default date filter' do
        payment_transaction = create(:payment_transaction, created_at: Date.today)
        payment_transaction_pattern[:id] = payment_transaction.id
        pattern = { data: [payment_transaction_pattern] }

        get :index

        expect(response.body).to be_json_as(pattern)
        expect(response).to have_http_status(:ok)
      end

      it 'not return the payment transaction after the end of default date filter' do
        create(:payment_transaction, created_at: Date.today + 1.day)
        pattern = { data: [] }

        get :index

        expect(response.body).to be_json_as(pattern)
        expect(response).to have_http_status(:ok)
      end

      it 'return the payment transaction on the start of default date filter' do
        createded_at = Date.today - PaymentTransactions::Get::DEFAULT_DAYS.days
        payment_transaction = create(:payment_transaction, created_at: createded_at)
        payment_transaction_pattern[:id] = payment_transaction.id
        pattern = { data: [payment_transaction_pattern] }

        get :index

        expect(response.body).to be_json_as(pattern)
        expect(response).to have_http_status(:ok)
      end

      it 'not return the payment transaction before the start of default date filter' do
        createded_at = Date.today - PaymentTransactions::Get::DEFAULT_DAYS.days - 1.day
        create(:payment_transaction, created_at: createded_at)
        pattern = { data: [] }

        get :index

        expect(response.body).to be_json_as(pattern)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when valid start_date and end_date filters are provided' do
      it 'returns only transactions within the provided date range' do
        before_filter = create(:payment_transaction, created_at: Date.today - 40.days)
        in_filter     = create(:payment_transaction, created_at: Date.today - 10.days)
        after_filter  = create(:payment_transaction, created_at: Date.today)
        payment_transaction_pattern[:id] = in_filter.id
        pattern = { data: [payment_transaction_pattern] }

        get :index, params: {
          start_date: (Date.today - 15.days).to_s,
          end_date: (Date.today - 5.days).to_s
        }

        expect(response.body).to be_json_as(pattern)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid date filters are provided' do
      it 'returns unprocessable entity with errors when start_date is after end_date' do
        pattern = { start_date: [I18n.t('errors.start_date_after_end_date')] }

        get :index, params: {
          start_date: Date.today.to_s,
          end_date: (Date.today - 5.days).to_s
        }

        expect(response.body).to be_json_as(pattern)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns unprocessable entity if only start_date is provided and is in the future' do
        future_date = (Date.today + 5.days).to_s
        pattern = { start_date: [I18n.t('errors.start_date_before_end_date')] }

        get :index, params: { start_date: future_date }

        expect(response.body).to be_json_as(pattern)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns unprocessable entity if only end_date is before default start date' do
        default_days = PaymentTransactions::Get::DEFAULT_DAYS
        future_date  = (Date.today - default_days.days - 1.day).to_s
        pattern      = { end_date: [I18n.t('errors.end_date_after_days_ago', days: default_days)] }

        get :index, params: { end_date: future_date }

        expect(response.body).to be_json_as(pattern)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #create' do
    context 'successful' do
      it 'when use valid params' do
        post :create, params: valid_attributes

        expect(response.body).to be_json_as(payment_transaction_pattern)
        expect(response).to have_http_status(:created)
        expect(Gateways::FakeGateway::SendWorker).to have_enqueued_sidekiq_job(body['id'])
      end
    end

    context 'failure' do
      context 'when gateway is fake_gateway' do
        it 'when installments is odd' do
          valid_attributes[:installments] = 1
          pattern = {
            installments: [I18n.t('errors.gateways.fake_gateway.installments_odd')]
          }

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
      end

      context 'when amount' do
        it 'not send' do
          pattern = { amount: [I18n.t('dry_validation.errors.key?')] }
          valid_attributes.delete(:amount)

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
        it 'is nil' do
          pattern = { amount: [I18n.t('dry_validation.errors.filled?')] }
          valid_attributes[:amount] = nil

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
        it 'is negative' do
          pattern = { amount: [I18n.t('dry_validation.errors.gt?', num: 0)] }
          valid_attributes[:amount] = -1

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
      end

      context 'when installments' do
        it 'not send' do
          pattern = { installments: [I18n.t('dry_validation.errors.key?')] }
          valid_attributes.delete(:installments)

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
        it 'is nil' do
          pattern = { installments: [I18n.t('dry_validation.errors.filled?')] }
          valid_attributes[:installments] = nil

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
        it 'is negative' do
          pattern = { installments: [I18n.t('dry_validation.errors.gteq?', num: 1)] }
          valid_attributes[:installments] = -1

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
        it 'is greate then 12' do
          pattern = { installments: [I18n.t('dry_validation.errors.lteq?', num: 12)] }
          valid_attributes[:installments] = 13

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
      end

      context 'when payment_method' do
        it 'not send' do
          pattern = { payment_method: [I18n.t('dry_validation.errors.key?')] }
          valid_attributes.delete(:payment_method)

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
        it 'is nil' do
          pattern = { payment_method: [I18n.t('dry_validation.errors.filled?')] }
          valid_attributes[:payment_method] = nil

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
        it 'is negative' do
          valid_attributes[:payment_method] = -1
          pattern = {
            payment_method: [I18n.t('dry_validation.errors.inclusion?',
                                    list: ::PaymentTransaction::PAYMENT_METHODS.join(', '))]
          }

          post :create, params: valid_attributes

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to be_json_as(pattern)
        end
      end
    end
  end

  # describe 'GET #index' do
  #   before do
  #     create_list(:payment_transaction, 3)
  #   end

  #   it 'returns a successful response' do
  #     get :index
  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'returns all payment_transactions' do
  #     get :index
  #     json_response = JSON.parse(response.body)
  #     expect(json_response.size).to eq(3)
  #   end
  # end
end
