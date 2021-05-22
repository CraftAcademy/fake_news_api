Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth', controllers: {
    sessions: 'api/sessions', 
    registrations: 'api/registrations'
  }
  namespace :api do
    resources :ratings, only: [:create]
    resources :articles, only: [:index, :show, :create, :update]
  end
end
