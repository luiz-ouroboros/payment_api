Rails.application.routes.draw do
  resources :payment_transactions, only: [:create, :index]
  resources :receivables, only: [:index]
end
