Rails.application.routes.draw do
  devise_for :user

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: '/auth'

      resources :users, only: [:index, :show], param: :nickname
      resources :victories, only: [:index, :show, :create, :destroy]
    end
  end
end
