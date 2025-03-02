require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'Settle Receivables - Daily at midnight',
  cron: '0 0 * * *',
  class: 'SettleReceivablesWorker'
)
