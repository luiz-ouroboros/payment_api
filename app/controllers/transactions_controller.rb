class TransactionsController < ApplicationController
  def index
    transactions = Transaction.all
    render json: transactions, status: :ok
  end

  def create
    transaction = Transaction.new(transaction_params)
    transaction.status = transaction.installment.even? ? 'aprovado' : 'reprovado'

    if transaction.save
      render json: transaction, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.permit(:amount, :installment, :payment_method)
  end
end
