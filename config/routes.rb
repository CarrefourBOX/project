Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  get 'profile', to: 'users#profile'

  root to: 'pages#start'
  get 'start', to: 'pages#start', as: :start
  get 'home', to: 'pages#home', as: :home
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get 'my_boxes', to: 'pages#my_boxes', as: :my_boxes

  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
  end

  resources :plans, only: %i[new create show]
  resources :box_names, only: %i[create destroy]
  resources :box_items, only: %i[create destroy]
end
