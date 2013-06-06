class ActivitiesController < ApiController
  respond_to :html

  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_filter :load_resource, only: [:show, :edit, :update, :destroy]
  authorize_resource only: [:edit, :update, :destroy]

  def index
    @activities = current_event.search_activities(current_user, query_params[:search], query_params[:filter])
    respond_with(@activities)
  end

  def show
    respond_with(@activity)
  end

  def new
    @activity = current_event.new_activity(current_user, {})
    respond_with(@activity)
  end

  def edit
    respond_with(@activity, status: :not_found)
  end

  def create
    @activity = current_event.new_activity(current_user, sanitized_params)
    @activity.save
    respond_with(@activity, location: activities_path)
  end

  def update
    @activity.update_attributes(sanitized_params)
    respond_with(@activity, location: edit_activity_path(@activity))
  end

  def destroy
    @activity.destroy
    respond_with(@activity, location: activities_path)
  end

  private

    def load_resource
      @activity = current_event.activity(params[:id]).decorate
    end

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

    def query_params
      params.permit(:search, :filter)
    end

end
