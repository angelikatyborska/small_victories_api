class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController
  include Api::V1::RegistrationsDoc
end