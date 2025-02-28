require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:valid_attributes) do
    {
      amount: 1000.00,
      installment: 10,
      payment_method: 'visa'
    }
  end

  let(:invalid_attributes) do
    {
      amount: nil,
      installment: nil,
      payment_method: ''
    }
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Transaction' do
        expect {
          post :create, params: { transaction: valid_attributes }
        }.to change(Transaction, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: { transaction: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Transaction' do
        expect {
          post :create, params: { transaction: invalid_attributes }
        }.to_not change(Transaction, :count)
      end

      it 'returns an unprocessable entity response' do
        post :create, params: { transaction: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #index' do
    before do
      create_list(:transaction, 3)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all transactions' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
    end
  end
end
