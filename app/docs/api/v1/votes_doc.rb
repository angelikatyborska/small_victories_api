module Api::V1::VotesDoc
  extend Apipie::DSL::Concern

  def self.superclass
    Api::V1::VotesController
  end

  resource_description do
    resource_id 'Votes'
    short 'Votes for users\' small victories - "like" (+1) or "dislike" (-1) a victory'
    formats ['JSON']
    api_version '1'
  end

  api :GET, '/v1/victories/:victory_id/votes'
  param :victory_id, :number, required: true

  def index
  end

  api :POST, '/v1/victories/:victory_id/votes'
  error code: 404, desc: 'Victory not found'
  error code: 403, desc: 'Must be logged in as the user for which a vote is being added'
  error code: 422, desc: 'Invalid vote param'
  param :victory_id, :number, required: true
  param :vote, Hash, required: true do
    param :value, ['1', '-1']
    param :user_id, :number
  end

  def create
  end

  api :PUT, '/v1/victories/:victory_id/votes/:id'
  error code: 404, desc: 'Victory not found'
  error code: 403, desc: 'Must be logged in as the user for which a vote is being updated'
  error code: 422, desc: 'Invalid vote param'
  param :victory_id, :number, required: true
  param :id, :number, require: true
  param :vote, Hash, required: true do
    param :value, ['1', '-1']
  end

  def update
  end

  api :DELETE, '/v1/victories/:victory_id/votes/:id'
  error code: 404, desc: 'Victory or vote not found'
  error code: 403, desc: 'Must be logged in as the user for which a vote is being deleted'
  param :victory_id, :number, required: true
  param :id, :number, require: true

  def destroy
  end
end