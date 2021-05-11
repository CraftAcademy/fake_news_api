Rails.application.routes.draw do
  namespace :api do
    get 'articles/index'
  end
  namespace :api do
    resources :articles, only: [:index]
  end
end
