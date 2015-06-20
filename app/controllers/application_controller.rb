class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_event
  layout :layout_by_resource

  before_filter :clean_up_session
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied, with: :rescue_access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_record_not_found

  def current_event
    @current_event ||= Event.new
  end

  def not_found
    if request.xhr?
      render nothing: true, status: 404
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

    def authenticate_user_from_token!
      authenticate_with_http_token do |token, options|
        user_email = options[:email].presence
        user = user_email && User.find_by_email(user_email)

        if user && Devise.secure_compare(user.authentication_token, token)
          sign_in user, store: false
        end
      end
    end

    def clean_up_session
      session[:omniauth] = nil
    end

    def rescue_access_denied
      render nothing: true, status: 401
    end

    def rescue_record_not_found
      not_found
    end

    def layout_by_resource
      devise_controller? ? 'user' : 'application'
    end

end
