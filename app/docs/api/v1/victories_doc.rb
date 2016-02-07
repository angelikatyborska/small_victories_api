module Api::V1::VictoriesDoc
  extend Apipie::DSL::Concern

  def self.superclass
    Api::V1::VictoriesController
  end

  resource_description do
    resource_id 'Victories'
    short 'Users\' small victories - short stories about their successes'
    formats ['JSON']
    api_version '1'
  end

  api :GET, '/v1/victories'
  param :page, :number
  param :per_page, :number
  param :sort, /^(\+|-)(id|body|created_at|rating)(,(\+|-)(id|body|created_at|rating))*$/, desc: 'Sorting order, default: -created_at'
  param :user, String, desc: ''

  def index
  end

  api :GET, '/v1/victories/:id'
  error code: 404, desc: 'Victory not found'
  param :id, :number, required: true

  def show
  end

  api :POST, '/v1/victories'
  error code: 403, desc: 'Must be logged in as the user for which a victory is being added'
  error code: 422, desc: 'Invalid victory param'
  param :victory, Hash, desc: 'Victory info', required: true do
    param :body, String, required: true
    param :user_id, :number, required: true
  end

  def create
  end

  api :DELETE, '/v1/victories/:id'
  error code: 403, desc: 'Must be logged in as the user whose victory is being deleted'
  error code: 404, desc: 'Victory not found'
  param :id, :number, required: true

  def destroy
  end
end