Langtrainer::Application.routes.draw do
  root :to => 'main_page#show'

  resources :user_sessions

  resource :user_registration, path: :registration, only: [:edit, :update]
  get '/confirm_email' => 'user_registrations#confirm_email', as: :confirm_email
  put '/reset_email_confirmation' => 'user_registrations#reset_email_confirmation', as: :reset_email_confirmation
  resource :token_authentication, only: :create

  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  resources :feedbacks, only: [:new, :create]

  resource :oauth do
    get :callback
  end
  match 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

  namespace :admin do
    get '/' => 'application#dashboard', as: :dashboard
    resources :sentences
    resources :feedbacks, only: [:index, :show, :destroy]
  end

  namespace :users do
    get 'dashboard' => 'user_profile#dashboard', as: :dashboard
    resources :exercises, except: :show
    resources :sentences
    resources :corrections, only: [:create, :update, :destroy], format: :json, constraints: { format: :json }
  end

  resources :languages, only: [], path: '' do
    resources :exercises, only: :show, path: ''
    put 'set_native', on: :member
  end
end
