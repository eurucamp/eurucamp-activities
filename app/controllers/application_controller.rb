class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_event

  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied, :with => :rescue_access_denied
  rescue_from ActiveRecord::RecordNotFound, :with => :rescue_record_not_found

  def current_event
    @current_event ||= Event.new(Settings.event.name, Settings.event.start_time, Settings.event.end_time)
  end

  def not_found
    if request.xhr?
      render :nothing => true, :status => 404
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

    def rescue_access_denied
      render :nothing => true, :status => 401
    end

    def rescue_record_not_found
      not_found
    end

end
