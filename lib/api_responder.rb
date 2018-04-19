
class ApiResponder < ActionController::Responder
  def to_html
    if get? && resource.nil?
      raise ActionController::RoutingError, 'Not Found'
    else
      super
    end
  end

  protected

  # This is the common behavior for formats associated with APIs, such as :xml and :json.
  def api_behavior(error)
    raise error unless resourceful?

    if get?
      resource.nil? ? display(resource, status: :not_found) : display(resource)
    elsif post?
      display resource, status: :created, location: api_location
    else
      head :no_content
    end
  end
end
