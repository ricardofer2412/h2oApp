Rails.application.routes.draw do
  resources :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

post 'fetch_balance' => 'accounts#fetch_balance', as: :fetch_balance

end
