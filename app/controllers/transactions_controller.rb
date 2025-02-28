class TransactionsController < ApplicationController
  def index
    transactions = Transaction.all
    render json: transactions, status: :ok
  end

  def create
    process_usecase(Transactions::Create) { |result|
      render json: result[:transaction], status: :created
    }
  end
end
