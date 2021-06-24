Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#start'
  get 'start', to: 'pages#start', as: :start
  get 'home', to: 'pages#home', as: :home
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
  get 'my_boxes', to: 'pages#my_boxes', as: :my_boxes

  resources :plans, only: %i[new create], shallow: true do
    member do
      put '/toggle_auto_renew', to: 'plans#toggle_auto_renew', as: :toggle_auto_renew
    end
  end
  resources :box_names, only: %i[create destroy]
  resources :box_items, only: %i[new create destroy]
end
