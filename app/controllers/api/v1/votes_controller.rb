class Api::V1::VotesController < Api::V1::ApplicationController
  def index
    @votes = Vote.where(victory_id: params[:victory_id])

    render json: ActiveModel::ArraySerializer.new(
      @votes,
      each_serializer: Api::V1::VoteSerializer
    )
  end
end