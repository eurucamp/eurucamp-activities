# -*- encoding : utf-8 -*-
class ApiResponder < ActionController::Responder
  def resourceful?
    true
  end

  def display(resource, given_options={})
    opts   = options.except(:prefixes, :template, :layout)
    status = given_options.delete(:status) || :ok
    runner = Yaks.global_config.runner(resource, {
      env: controller.env
    }.merge(opts).merge(given_options))

    controller.render text: runner.call,
      content_type: runner.media_type,
      status: status
  end

  protected

    # This is the common behavior for formats associated with APIs, such as :xml and :json.
    def api_behavior(error)
      raise error unless resourceful?

      if get?
        resource.nil? ? display(resource, status: :not_found) : display(resource)
      elsif has_errors?
        render json: { errors: resource.errors }, status: :unprocessable_entity
      elsif post?
        display resource, status: :created, location: api_location
      elsif put? or patch?
        display resource, location: api_location
      else
        head :no_content
      end
    end

end
