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
    authorize!(:edit, @activity)
    respond_with(@activity)
  end

  def create
    @activity = current_event.new_activity(current_user, sanitized_params)
    @activity.save
    respond_with(@activity, location: activities_path)
  end

  def update
    @activity = current_event.activity(params[:id])
    authorize!(:update, @activity)
    @activity.update_attributes(sanitized_params)
    respond_with(@activity)
  end

  def destroy
    @activity = current_event.activity(params[:id])
    authorize!(:destroy, @activity)
    @activity.destroy
    respond_with(@activity)
  end

  private

    def sanitized_params
      params.require(:activity)
            .permit(:start_time,
                    :end_time,
                    :name,
                    :location,
                    :requirements,
                    :description,
                    :limit_of_participants,
                    :anytime,
                    :image_url)
    end

end
