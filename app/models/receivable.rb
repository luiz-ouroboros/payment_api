class Receivable < ApplicationRecord
  belongs_to :transaction

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
end
