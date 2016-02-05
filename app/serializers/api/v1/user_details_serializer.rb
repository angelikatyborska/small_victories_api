class Api::V1::UserDetailsSerializer < Api::V1::UserSerializer
  class VictorySerializer < Api::V1::BaseSerializer
    attributes :id, :body, :created_at
  end

  class VoteSerializer < Api::V1::BaseSerializer
    attributes :value, :id, :victory_id
  end

  attributes :email

  has_many :victories, serializer: VictorySerializer
  has_many :votes, serializer: VoteSerializer
end
