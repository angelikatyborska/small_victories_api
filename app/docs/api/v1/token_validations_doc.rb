module Api::V1::TokenValidationsDoc
  extend Api::V1::BaseDoc
  namespace '/api/v1'
  resource :token_validations, formats: ['JSON']

  doc_for :validate_token do
    api :GET, '/validate_token', 'Validate user\'s token'
    auth_headers
  end
end