Rails.application.routes.draw do
  resources :transactions, only: [:create, :index]
  resources :receivables, only: [:index]
end
