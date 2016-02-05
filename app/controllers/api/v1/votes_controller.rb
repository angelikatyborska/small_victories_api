class Api::V1::VotesController < Api::V1::ApplicationController
  def index
    @victory =  Victory.find(params[:victory_id])

    not_found if @victory.nil?

    @votes = @victory.votes.includes(:user)

    render json: ActiveModel::ArraySerializer.new(
      @votes,
      each_serializer: Api::V1::VoteSerializer
    )
  end

  def create
    @victory =  Victory.find(params[:victory_id])

    not_found if @victory.nil?

    @vote = @victory.votes.new(vote_params)

    if authorize_user!(@vote.user)
      if @vote.save
        render json: Api::V1::VoteSerializer.new(@vote).to_json
      else
        render json: Api::V1::ErrorsSerializer.new(@vote.errors).to_json, status: 422
      end
    end
  end

  def destroy
    @victory =  Victory.find(params[:victory_id])

    not_found if @victory.nil?

    @vote = @victory.votes.find(params[:id])

    if authorize_user!(@vote.user)
      @vote.destroy

      head :no_content
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:user_id, :victory_id, :value)
  end
end