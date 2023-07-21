Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :meetings #, except: [ :destroy ]
      resources :bookings #, only: [ :index, :show]

      root to: "users#index"
    end
  devise_for :users
  root 'pages#home'
  
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'dashboard', to: 'pages#dashboard'
  get 'thank_you', to: 'pages#thank_you'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
