class Api::V1::VictorySerializer < Api::V1::BaseSerializer
  attributes :id, :body, :created_at, :votes_count

  has_one :user, serializer: Api::V1::UserSerializer
end