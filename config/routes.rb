Rails.application.routes.draw do
  resources :transactions, only: %i(create index show)
  resources :accounts, only: %i(create index show)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
