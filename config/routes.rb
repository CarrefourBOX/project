Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  get 'profile', to: 'users#profile'

  root to: 'pages#home'
  get 'start', to: 'pages#start', as: :start
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get 'my_box', to: 'pages#my_box', as: :my_box
  get 'my_addresses', to: 'pages#my_addresses', as: :my_addresses
  get 'cancel', to: 'pages#cancel', as: :cancel

  post 'fetch_address', to: 'ceps#fetch_address', as: :fetch_address
  post 'calculate_shipment', to: 'ceps#calculate_shipment', as: :calculate_shipment

  resources :plans, only: %i[new create show destroy update], shallow: true do
    member do
      patch '/update', to: 'plans#update_my_box'
      patch '/cancel_box', to: 'plans#cancel_box'
    end
  end
  post :shopcart, to: 'plans#shopcart'

  resources :orders, only: %i[show create] do
    member do
      get 'confirm_payment', to: 'orders#confirm_payment', as: :confirm_payment
    end
    resources :payments, only: :new
  end
  resources :carrefour_boxes, only: %i[create show update destroy] do
    resources :reviews, only: %i[create update destroy], shallow: true
  end

  resources :box_items, only: %i[new create destroy]
  resources :addresses, only: %i[create update destroy]
end
