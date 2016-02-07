class Api::V1::UsersController < Api::V1::ApplicationController
  include Api::V1::UsersDoc

  def index
    @users = User.all

    render json: ActiveModel::ArraySerializer.new(
      @users,
      each_serializer: Api::V1::UserSerializer
    )
  end

  def show
    @user = User.includes(:victories).find_by(nickname: params[:nickname])

    if @user.nil?
      not_found
    else
      render json: Api::V1::UserDetailsSerializer.new(@user).to_json
    end
  end
end