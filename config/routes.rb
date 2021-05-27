Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth', controllers: {
    sessions: 'api/sessions',
    registrations: 'api/registrations'
  }
  namespace :api do
    resources :ratings, only: [:create]
    resources :articles, only: %i[index show create update destroy]
    resources :backyards, only: %i[index show create, destroy]
    resources :statistics, only: [:index]
  end
end
