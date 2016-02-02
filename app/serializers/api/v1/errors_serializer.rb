class Api::V1::ErrorsSerializer < Api::V1::BaseSerializer
  def to_json
    hash = { errors: [] }

    @object.keys.each { |key| hash[:errors] << { key => @object[key]  } }

    hash.to_json
  end
end