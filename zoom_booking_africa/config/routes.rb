Rails.application.routes.draw do
  root 'pages#home'
  
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'dasboard', to: 'pages#dasboard'
  get 'thank_you', to: 'pages#thank_you'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
