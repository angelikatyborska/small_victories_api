class Api::V1::BaseSerializer < ActiveModel::Serializer
  self.root = false

  def created_at
    object.created_at.utc.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.utc.iso8601 if object.created_at
  end
end