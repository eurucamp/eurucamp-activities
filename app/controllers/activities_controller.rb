class ActivitiesController < ApplicationController
  respond_to :json, :html, :only => :index
  respond_to :json

  def index
    @activities = current_event.activities.decorate
    respond_with(@activities)
  end

  def create
    @activity = current_event.new_activity(current_user, sanitized_params)
    @activity.save
    respond_with(@activity)
  end

  def update
    @activity = current_event.activity(params[:id])
    @activity.update_attributes(sanitized_params)
    respond_with(@activity)
  end

  private

    def sanitized_params
      params.require(:activity).permit(:start_at, :name, :place, :limit_of_participants, :time_frame)
    end

end
