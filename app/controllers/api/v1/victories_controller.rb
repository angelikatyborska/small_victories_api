class Api::V1::VictoriesController < Api::V1::ApplicationController
  before_action :authorize_user!, only: [:create, :destroy, :update]

  def index
    @victories = Victory.all

    render json: ActiveModel::ArraySerializer.new(
      @victories,
      each_serializer: Api::V1::VictorySerializer,
      root: 'victories'
    )
  end

  def show
    @victory = Victory.find(params[:id])

    render json: Api::V1::VictorySerializer.new(@victory).to_json
  end

  private

  def victory_params
    params.require(:victory).permit(:user_id, :body)
  end

  def authorize_user!
    return true if user_signed_in? && victory.user && current_user == victory.user

    # 404 or 401 - which one should be here?
    not_found
  end
end