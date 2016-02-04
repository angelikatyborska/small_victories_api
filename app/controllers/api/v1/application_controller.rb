class Api::V1::ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  DEFAULT_SORT_PARAMS = { created_at: :desc }

  def destroy_session
    request.session_options[:skip] = true
  end

  def not_found
    head 404
  end

  def sort_params(model)
    sort_params = {}

    if params[:sort]
      sorts = params[:sort].split(',')
      sorts.each do |sort|
        order = sort[0] === '-' ? 'desc' : 'asc'
        attribute = sort[1..-1]
        sort_params[attribute] = order if model.column_names.include?(attribute)
      end
    end

    sort_params.empty? ? DEFAULT_SORT_PARAMS : sort_params
  end
end
