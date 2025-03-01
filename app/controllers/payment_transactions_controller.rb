class PaymentTransactionsController < ApplicationController
  def index
    payment_transactions = PaymentTransaction.all
    render json: payment_transactions, status: :ok
  end

  def create
    process_usecase(::PaymentTransactions::Create) { |result|
      render json: result[:payment_transaction], status: :created
    }
  end
end
