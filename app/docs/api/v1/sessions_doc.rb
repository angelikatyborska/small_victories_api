module Api::V1::SessionsDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'
  resource :sessions, formats: ['JSON']

  doc_for :sign_in do
    api :POST, '/v1/auth/sign_in', 'Sign in a user, returns user\'s Access-Token, Client and Uid headers'
    param :email, String, required: true
    param :password, String, required: true
  end

  doc_for :sign_out do
    api :DELETE, '/v1/auth/sign_out', 'Sign out a user, requires authentication'
    auth_headers
  end
end