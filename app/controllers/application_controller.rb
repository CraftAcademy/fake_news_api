class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {error_message: exception}, status: 404
  end
end
