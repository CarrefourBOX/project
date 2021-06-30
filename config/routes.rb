Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  get 'profile', to: 'users#profile'

  root to: 'pages#home'
  get 'start', to: 'pages#start', as: :start
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get 'my_boxes', to: 'pages#my_boxes', as: :my_boxes
  get 'cancel', to: 'pages#cancel', as: :cancel

  resources :plans, only: %i[new create show destroy], shallow: true do
    member do
      put '/toggle_auto_renew', to: 'plans#toggle_auto_renew', as: :toggle_auto_renew
    end
  end
  get :shopcart, to: 'plans#shopcart'

  resources :orders, only: %i[show create] do
    member do
      get 'confirm_payment', to: 'orders#confirm_payment', as: :confirm_payment
    end
    resources :payments, only: :new
  end
  resources :carrefour_boxes, only: %i[create show destroy update] do
    resources :reviews, only: %i[new create update destroy]
  end
  resources :box_items, only: %i[new create destroy]
end
