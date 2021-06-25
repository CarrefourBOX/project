Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  get 'profile', to: 'users#profile'

  root to: 'pages#home'
  get 'start', to: 'pages#start', as: :start
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get 'my_boxes', to: 'pages#my_boxes', as: :my_boxes

  resources :plans, only: %i[new create show], shallow: true do
    member do
      put '/toggle_auto_renew', to: 'plans#toggle_auto_renew', as: :toggle_auto_renew
    end
  end

  resources :orders, only: %i[show create] do
    member do
      get 'confirm_payment', to: 'orders#confirm_payment', as: :confirm_payment
    end
    resources :payments, only: :new
  end
  resources :box_names, only: %i[create destroy]
  resources :box_items, only: %i[new create destroy]
end
