Rails3BootstrapDeviseCancan::Application.routes.draw do
  root :to => 'exercises#index'

  resources :users do
    get :activate, on: :member
  end

  resources :user_sessions
  resources :password_resets

  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  get 'signup' => 'users#new', :as => :signup

  resource :oauth do
    get :callback
  end
  match 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

  namespace :admin do
    resources :sentences
  end

  resources :exercises, only: :show
end
