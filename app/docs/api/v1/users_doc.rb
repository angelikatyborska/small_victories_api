module Api::V1::UsersDoc
  extend Apipie::DSL::Concern

  def self.superclass
    Api::V1::UsersController
  end

  resource_description do
    resource_id 'Users'
    short 'Site members'
    formats ['JSON']
    api_version '1'
  end

  api :GET, '/v1/users'

  def index
  end

  api :GET, '/v1/users/:nickname'
  param :nickname, String, required: true
  error code: 404, desc: 'User not found'

  def show
  end
end
