Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get 'my_boxes', to: 'pages#my_boxes', as: :my_boxes

  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
  end

  resources :plans, only: %i[new create]
  resources :box_names, only: %i[create destroy]
  resources :box_items, only: %i[create destroy]
end
