class Api::V1::VoteSerializer < Api::V1::BaseSerializer
  attributes :value, :id

  has_one :user, serializer: Api::V1::UserSerializer
end