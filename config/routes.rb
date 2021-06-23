Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#start'
  get 'start', to: 'pages#start', as: :start
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get 'my_boxes', to: 'pages#my_boxes', as: :my_boxes

  resources :plans, only: %i[new create]
  resources :box_names, only: %i[create destroy]
  resources :box_items, only: %i[create destroy]
end
