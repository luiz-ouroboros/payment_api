class PaymentTransaction < ApplicationRecord
  audited

  has_many :receivables, dependent: :destroy

  STATUS_SENDING       = 'sending'.freeze
  STATUS_APPROVED      = 'approved'.freeze
  STATUS_REPROVED      = 'reproved'.freeze
  STATUS_SENDING_ERROR = 'sending_error'.freeze

  STATUSES = [
    STATUS_SENDING,
    STATUS_APPROVED,
    STATUS_REPROVED,
    STATUS_SENDING_ERROR
  ].freeze

  enum :status, {
    sending: STATUS_SENDING,
    approved: STATUS_APPROVED,
    reproved: STATUS_REPROVED,
    sending_error: STATUS_SENDING_ERROR,
  }

  PAYMENT_METHOD_VISA   = 'visa'.freeze
  PAYMENT_METHOD_MASTER = 'master'.freeze

  PAYMENT_METHODS = [
    PAYMENT_METHOD_VISA,
    PAYMENT_METHOD_MASTER,
  ].freeze

  enum :payment_method, {
    visa: PAYMENT_METHOD_VISA,
    master: PAYMENT_METHOD_MASTER,
  }

  def fee
    InstallmentFee.find_by(gateway: gateway, installments: installments)&.fee_percentage
  end

  def retention_value
    return if fee.nil?
    return if amount.nil?

    amount * (fee / 100)
  end

  def retention_value!
    retention_value || raise(ArgumentError, 'fee or amount is nil')
  end

  def transfer_value
    return if retention_value.nil?

    amount - retention_value
  end

  def transfer_value!
    transfer_value || raise(ArgumentError, 'fee or amount is nil')
  end
end
