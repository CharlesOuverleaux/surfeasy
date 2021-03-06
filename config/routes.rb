Rails.application.routes.draw do
  # sidekiq admin
  require "sidekiq/web"
  devise_for :users
  root to: 'pages#home'
  resources :spots, only: [:index, :show] do
    resources :reviews, only: [ :new, :create ]
    resources :favorites, only: [ :new, :create ]
  end
  resources :reviews, only: [ :destroy ]
  resources :favorites, only: [ :destroy ]
  # profile routes
  get '/profile', to: 'profile#index'
  get '/signout', to: 'profile#signout'
  # footer routes
  get '/team', to: 'pages#team'
  get '/about', to: 'pages#about'
  get '/donate', to: 'pages#donate'
end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
