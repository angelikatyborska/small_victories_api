class Api::V1::UserDetailsSerializer < Api::V1::UserSerializer
  class VictorySerializer < Api::V1::BaseSerializer
    attributes :id, :body, :created_at
  end

  attributes :email

  has_many :victories, serializer: VictorySerializer
end
