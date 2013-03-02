Langtrainer::Application.routes.draw do
  root :to => 'exercises#index'

  resources :user_sessions

  resource :user_registration, path: :registration, only: [:edit, :update]
  get '/confirm_email' => 'user_registrations#confirm_email', as: :confirm_email
  resource :token_authentication, only: :create

  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  resource :oauth do
   get :callback
  end
  match 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

  namespace :admin do
    get '/' => 'application#dashboard', as: :dashboard
    resources :sentences
  end

  resources :exercises, only: :show
end
