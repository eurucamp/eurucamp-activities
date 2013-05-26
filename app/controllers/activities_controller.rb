class ActivitiesController < ApplicationController
  respond_to :json, :html, :only => :index
  respond_to :json, :only => [:create]

  def index
    @activities = current_event.activities.decorate
    respond_with(@activities)
  end

  def create
    sanitized_params = params.require(:activity).permit(:start_at, :name, :place, :limit_of_participants, :time_frame)
    @activity = current_event.new_activity(sanitized_params)
    @activity.creator = current_user
    @activity.save
    respond_with(@activity)
  end

end
