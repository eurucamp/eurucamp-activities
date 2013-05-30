class ActivitiesController < ApplicationController
  respond_to :html

  skip_before_filter :authenticate_user!, :only => [:index, :show]

  def index
    @activities = current_event.activities
    respond_with(@activities)
  end

  def show
    @activity = current_event.activity(params[:id])
    respond_with(@activity)
  end

  def new
    @activity = current_event.new_activity(current_user, {})
    respond_with(@activity)
  end

  def edit
    @activity = current_event.activity(params[:id])
    respond_with(@activity)
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

  def destroy
    @activity = current_event.activity(params[:id])
    @activity.destroy if @activity && @activity.creator == current_user #TODO
    respond_with(@activity)
  end

  private

    def sanitized_params
      params.require(:activity).permit(:start_time, :end_time, :name, :place, :limit_of_participants)
    end

end
