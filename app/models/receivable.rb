class Receivable < ApplicationRecord
  audited

  belongs_to :payment_transaction
  delegate :gateway, :installments, :fee, to: :payment_transaction

  STATUS_PENDING   = 'pending'.freeze
  STATUS_SETTLED   = 'settled'.freeze

  STATUSES = [
    STATUS_PENDING,
    STATUS_SETTLED,
  ].freeze

  enum :status, {
    pending: STATUS_PENDING,
    settled: STATUS_SETTLED,
  }

  def retention_value
    return if payment_transaction.retention_value.nil?

    payment_transaction.retention_value / installments
  end

  def retention_value!
    retention_value || raise(ArgumentError, 'fee or amount of payment_transaction is nil')
  end

  def transfer_value
    return if retention_value.nil?

    payment_transaction.transfer_value / installments
  end

  def transfer_value!
    transfer_value || raise(ArgumentError, 'fee or amount of payment_transaction is nil')
  end
end
