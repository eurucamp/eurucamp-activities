class ApiController < ApplicationController

  self.responder = ApiResponder

  rescue_from ActionController::ParameterMissing do |exception|
    render json:   { errors: "Required parameter missing: #{exception.param}" },
           status: :bad_request
  end
end
