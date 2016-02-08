class Api::V1::TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  include Api::V1::TokenValidationsDoc
end