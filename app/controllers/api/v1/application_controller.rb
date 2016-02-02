class Api::V1::ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def destroy_session
    request.session_options[:skip] = true
  end

  def not_found
    head 404
  end
end
