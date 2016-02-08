class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  include Api::V1::SessionsDoc
end