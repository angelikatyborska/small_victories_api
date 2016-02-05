class Api::V1::VictoriesController < Api::V1::ApplicationController
  after_action only: [:index] { set_pagination_headers(:victories) }

  def index
    order = sort_params(Victory)

    @victories = Victory
      .order(order)
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
        # TODO: this or redirect to show?
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