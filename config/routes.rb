Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth', controllers: {
    sessions: 'api/sessions'
  }
  namespace :api do
    resources :articles, only: [:index, :show, :create]
  end
end
