Rails.application.routes.draw do
  root "home#index"
  devise_for :users
  resources :restaurants do
    post '/add_order', to: 'orders#add_order'
    resources :menu_items
  end
  resources :orders, only: [:show]
  get 'owner_dashboard/index'
  get 'restaurant/:id', to: 'owner_dashboard#show', as: 'dashboard'
  get "up" => "rails/health#show", as: :rails_health_check
end
