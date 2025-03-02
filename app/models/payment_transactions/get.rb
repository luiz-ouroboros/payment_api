class PaymentTransactions::Get < UseCase
  attributes :params

  DEFAULT_DAYS = (ENV['DEFAULT_DAYS']&.to_i || 30)
  DEFAULT_PER_PAGE = (ENV['DEFAULT_PER_PAGE']&.to_i || 20)

  class UseContract < ContractScheme
    params do
      optional(:start_date).maybe(:date)
      optional(:end_date).maybe(:date)
      optional(:page).maybe(:integer)
      optional(:per_page).maybe(::Types::PerPage)
    end

    rule(:start_date, :end_date) do
      if values[:start_date] && values[:end_date] && values[:start_date] > values[:end_date]
        key(:start_date).failure(I18n.t('errors.start_date_after_end_date'))
      end

      if values[:start_date] && values[:end_date].nil? && values[:start_date] > Date.today
        key(:start_date).failure(I18n.t('errors.start_date_before_end_date'))
      end

      if values[:start_date].nil? && values[:end_date] && values[:end_date] < Date.today - DEFAULT_DAYS.days
        key(:end_date).failure(I18n.t('errors.end_date_after_days_ago', days: DEFAULT_DAYS))
      end
    end
  end

  def call!
    validate_params(UseContract, params)
      .then(:load_payment_transactions)
      .then(:includes)
      .then(:filter_by_date)
      .then(:paginate)
      .then(:output)
  end

  private

  def load_payment_transactions(**)
    Success(:load_payment_transactions_success, result: { payment_transactions: PaymentTransaction.all })
  end

  def includes(payment_transactions:, **)
    Success(:includes_success, result: {
      payment_transactions: payment_transactions.includes(:receivables)
    })
  end

  def filter_by_date(params:, payment_transactions:, **)
    start_date = (params[:start_date] || Date.today - DEFAULT_DAYS.days).beginning_of_day
    end_date = (params[:end_date] || Date.today).end_of_day

    payment_transactions = payment_transactions.where(created_at: start_date...end_date)

    Success(:filter_by_date_success, result: {
      payment_transactions: payment_transactions
    })
  end

  def paginate(params:, payment_transactions:, **)
    per_page = params[:per_page] || DEFAULT_PER_PAGE
    page     = params[:page] || 1

    payment_transactions = payment_transactions.paginate(page: page, per_page: per_page)
                                               .order(id: :desc)

    meta = {
      paginate: {
        current_page: payment_transactions.current_page,
        per_page: payment_transactions.per_page,
        total: payment_transactions.total_entries,
        pages: payment_transactions.total_pages
      }
    }

    Success(:paginate_success, result: {
      payment_transactions: payment_transactions, meta: meta
    })
  end

  def output(payment_transactions:, meta:, **)
    Success(:get_success, result: { payment_transactions: payment_transactions, meta: meta })
  end
end
