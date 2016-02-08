module Api::V1::VotesDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'
  resource :votes, formats: ['JSON'], short: 'Votes for users\' small victories - "like" (+1) or "dislike" (-1) a victory'

  doc_for :index do
    api :GET, '/v1/victories/:victory_id/votes', 'Fetch data about all votes'
    param :victory_id, :number, required: true
  end

  doc_for :create do
    api :POST, '/v1/victories/:victory_id/votes', 'Create a vote for a victory, requires authentication'
    error code: 404, desc: 'Victory not found'
    error code: 403, desc: 'Must be logged in as the user for which a vote is being added'
    error code: 422, desc: 'Invalid vote param'
    auth_headers
    param :victory_id, :number, required: true
    param :vote, Hash, required: true do
      param :value, ['1', '-1']
      param :user_id, :number
    end
  end

  doc_for :update do
    api :PUT, '/v1/victories/:victory_id/votes/:id', 'Update vote\'s value, requires authentication'
    error code: 404, desc: 'Victory not found'
    error code: 403, desc: 'Must be logged in as the user for which a vote is being updated'
    error code: 422, desc: 'Invalid vote param'
    auth_headers
    param :victory_id, :number, required: true
    param :id, :number, require: true
    param :vote, Hash, required: true do
      param :value, ['1', '-1']
    end
  end

  doc_for :destroy do
    api :DELETE, '/v1/victories/:victory_id/votes/:id', 'Delete a vote, requires authentication'
    error code: 404, desc: 'Victory or vote not found'
    error code: 403, desc: 'Must be logged in as the user for which a vote is being deleted'
    auth_headers
    param :victory_id, :number, required: true
    param :id, :number, require: true
  end
end