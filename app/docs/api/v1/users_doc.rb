module Api::V1::UsersDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'
  resource :users, formats: ['JSON'], short: 'Site members'

  doc_for :index do
    api :GET, '/v1/users', 'Fetch basic data about all users'
  end

  doc_for :show do
    api :GET, '/v1/users/:nickname', 'Fetch detailed data about a user, requires authentication'
    error code: 404, desc: 'User not found'
    auth_headers
    param :nickname, String, required: true
  end
end
