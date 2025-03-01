require 'rails_helper'

RSpec.describe PaymentTransactionsController, type: :controller do
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

  describe 'GET #index' do
    before do
      create_list(:payment_transaction, 3)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all payment_transactions' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
    end
  end
end
