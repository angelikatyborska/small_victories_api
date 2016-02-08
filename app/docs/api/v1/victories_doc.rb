module Api::V1::VictoriesDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'
  resource :victories, formats: ['JSON'], short: 'Users\' small victories - short stories about their successes'

  doc_for :index do
    api :GET, '/v1/victories', 'Fetch data about victories, supports pagination, sorting and finding by user\'s nickname'
    param :page, :number
    param :per_page, :number
    param :sort, /^(\+|-)(id|body|created_at|rating)(,(\+|-)(id|body|created_at|rating))*$/, desc: 'Sorting order, default: -created_at'
    param :user, String, desc: ''
  end

  doc_for :show do
    api :GET, '/v1/victories/:id', 'Fetch data about a victory'
    error code: 404, desc: 'Victory not found'
    param :id, :number, required: true
  end

  doc_for :create do
    api :POST, '/v1/victories', 'Create a new victory, requires authentication'
    error code: 403, desc: 'Must be logged in as the user for which a victory is being added'
    error code: 422, desc: 'Invalid victory param'
    auth_headers
    param :victory, Hash, desc: 'Victory info', required: true do
      param :body, String, required: true
      param :user_id, :number, required: true
    end
  end

  doc_for :delete do
    api :DELETE, '/v1/victories/:id', 'Delete a new victory, requires authentication'
    error code: 403, desc: 'Must be logged in as the user whose victory is being deleted'
    error code: 404, desc: 'Victory not found'
    auth_headers
    param :id, :number, required: true
  end
end