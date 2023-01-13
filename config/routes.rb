Rails.application.routes.draw do
  resources :stocks
  devise_for :users, controllers: { confirmations: 'confirmations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/admin", to: "admin#index", as: "admin_path"
  put "/togle-status", to: "admin#toggle_account_status", as: "toggle_account_status_path"
  put "/toggle-admin", to: "admin#toggle_account_admin", as: "toggle_account_admin_path"
  get "/next", to: "stocks#next", as: "stocks_next_path"
  get "/inactive-account", to:"inactive_account#index"
  # Defines the root path route ("/")
  # root "articles#index"
  root "stocks#index"
end
