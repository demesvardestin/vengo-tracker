Rails.application.routes.draw do
  
  # API ROUTES
  namespace :api do
    resources :machines, except: [:new, :edit] do
      resources :products, except: [:new, :edit]
    end
  end
  # END API ROUTES
  
  
  # WEB SIMULATION ROUTES
  namespace :simulator do
    resources :machines, only: [:show, :index]
    post '/buy', to: "machines#buy"
    post '/refill', to: "machines#refill"
  end
  # END WEB SIMULATION ROUTES
  
  
  # WEB APP ROUTES
  devise_for :operators, :controllers => { :registration => "operators_auth/registration" }
  devise_scope :operator do
    get '/login', to: 'devise/sessions#new'
    get '/signup', to: 'devise/registrations#new'
  end
  authenticated :operator do
    root 'machines#index', as: :authenticated_operator_root
  end
  
  resources :machines do
    resources :products
  end
  
  resources :operators, only: [:create, :update] do
    get "/account", to: "operators#account", as: "account"
    get "/generate_secret_token", to: "operators#generate_secret_token"
  end
  
  get "/generate_random", to: "machines#generate_random"
  
  root "machines#index"
  # END WEB APP ROUTES
end
