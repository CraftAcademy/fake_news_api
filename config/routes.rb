Rails.application.routes.draw do
  namespace :api do
    resources :articles, only: [:index]
  end
  mount_devise_token_auth_for 'User', at: 'api/auth'

end
