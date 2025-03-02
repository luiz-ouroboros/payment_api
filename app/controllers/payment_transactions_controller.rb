class PaymentTransactionsController < ApplicationController
  def index
    process_usecase(PaymentTransactions::Get) { |result|
      render json: { data: result[:payment_transactions] }
    }
  end

  def create
    process_usecase(::PaymentTransactions::Create) { |result|
      render json: result[:payment_transaction], status: :created
    }
  end
end
