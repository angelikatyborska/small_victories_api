module Api::V1::RegistrationsDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'
  resource :registrations, formats: ['JSON']

  doc_for :create do
    api :POST, '/v1/auth', 'Register a user'
    param :email, String, required: true
    param :password, String, required: true
    param :password_confirmation, String, required: true
    param :nickname, String, required: true
  end

  doc_for :destroy do
    api :DELETE, '/v1/auth', 'Delete a user, requres authentication'
    auth_headers
  end
end