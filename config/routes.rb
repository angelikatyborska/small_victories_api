Rails.application.routes.draw do
  devise_for :user

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'

      resources :users, only: [:index, :show]
      resources :victories, only: [:index, :show, :create]
    end
  end
end
