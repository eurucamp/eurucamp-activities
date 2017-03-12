require_dependency 'api_responder'

class ApiController < ApplicationController

  self.responder = ApiResponder

end
