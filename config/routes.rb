Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth', controllers: {
    sessions: 'api/sessions',
    registrations: 'api/registrations'
  }
  namespace :api do
    resources :ratings, only: [:create]
    resources :articles, only: %i[index show create update destroy] do
      resources :comments, only: [:create]
    end
    resources :backyards, only: %i[index show create update]
    resources :statistics, only: [:index]
  end
end
