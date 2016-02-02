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
end