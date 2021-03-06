class Api::V1::VictoriesController < Api::V1::ApplicationController
  include Api::V1::VictoriesDoc

  after_action only: [:index] { set_pagination_headers(:victories) }

  def index
    order = sort_params(Victory)
    where = {}

    if params[:user]
      user = User.find_by(nickname: params[:user])
      where = user ? { user_id: user.id } : { user_id: nil }
    end

    @victories = Victory
      .includes(:user)
      .order(order)
      .where(where)
      .page(params[:page] || 1)
      .per(params[:per_page] || Kaminari.config.default_per_page)

    render json: ActiveModel::ArraySerializer.new(
      @victories,
      each_serializer: Api::V1::VictorySerializer
    )
  end

  def show
    @victory = Victory.find(params[:id])

    render json: Api::V1::VictorySerializer.new(@victory).to_json
  end

  def create
    @victory = Victory.new(victory_params)

    if authorize_user!(@victory.user)
      if @victory.save
        render json:  Api::V1::VictorySerializer.new(@victory).to_json
      else
        render json: Api::V1::ErrorsSerializer.new(@victory.errors).to_json, status: 422
      end
    end
  end

  def destroy
    @victory = Victory.find(params[:id])

    if authorize_user!(@victory.user)
      @victory.destroy

      head :no_content
    end
  end

  private

  def victory_params
    params.require(:victory).permit(:user_id, :body)
  end
end