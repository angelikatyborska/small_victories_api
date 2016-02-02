class Api::V1::VictoriesController < Api::V1::ApplicationController
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

  def create
    @victory = Victory.new(victory_params)

    if authorize_user!(@victory.user)
      if @victory.save
        # TODO: this or redirect to show?
        render json: Api::V1::VictorySerializer.new(@victory).to_json
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

  def authorize_user!(user)
    return true if user_signed_in? && current_user == user

    head 403

    false
  end
end