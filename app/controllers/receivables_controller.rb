class ReceivablesController < ApplicationController
  def index
    receivables = Receivable.joins(:payment_transaction).all

    if params_permitted[:payment_transaction_status].present?
      receivables = receivables.where(
        payment_transaction: { status: params_permitted[:payment_transaction_status] }
      )
    end

    render json: { data: receivables }, status: :ok
  end

  private

  def params_permitted
    params.permit(:payment_transaction_status)
  end
end
