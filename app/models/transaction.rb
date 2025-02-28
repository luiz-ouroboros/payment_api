class Transaction < ApplicationRecord
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
end
