Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  resources :restaurants do
    post '/add_order', to: 'orders#add_order'
  end
  resources :orders, only: [:show] do
    member do
      patch :update_status
    end
  end
  get 'owner_dashboard/index'
  scope 'restaurant/:restaurant_id', as: 'dashboard' do
    get '/', to: 'owner_dashboard#show'
    resources :menu_items
  end
  get 'dashboard', to: 'visitor_dashboard#show', as: :visitor_dashboard
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      post 'register', to: 'registrations#create'
      resources :restaurants, only: %i[index show] do
        resources :menu_items, only: [:index]
        post '/add_order', to: 'orders#create'
      end
      resources :orders, only: %i[index show create]
      get 'dashboard', to: 'dashboard#show'
    end
  end
end
