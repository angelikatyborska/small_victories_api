Rails.application.routes.draw do
  apipie

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

      resources :users, only: [:index, :show], param: :nickname, constraints: { :nickname => /[^\/]+/ }
      resources :victories, only: [:index, :show, :create, :destroy] do
        resources :votes, only: [:index, :create, :destroy, :update]
      end
    end
  end
end
