class Api::V1::VictorySerializer < Api::V1::BaseSerializer
  class UserSerializer < Api::V1::BaseSerializer
    attributes :id, :nickname
  end

  attributes :id, :body, :created_at

  has_one :user, serializer: UserSerializer
end