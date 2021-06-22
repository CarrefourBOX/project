Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get 'dashboard', to: 'pages#dashboard', as: :dashboard

  resources :box_names, only: %i[create destroy]
  resources :box_items, only: %i[create destroy]
end
