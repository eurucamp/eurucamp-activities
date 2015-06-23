class ActivitiesController < ApiController
  respond_to :json_api

  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_filter :load_resource, only: [:show, :edit, :update, :destroy]
  authorize_resource only: [:edit, :update, :destroy]

  def index
    @activities = current_event.search_activities(current_user, query_params[:search], query_params[:filter])
    @counters = current_event.counters(current_user)
    respond_with @activities
  end

  def show
    respond_with @activity
  end

  def create
    @activity = current_event.new_activity(current_user, sanitized_params)
    @activity.save
    respond_with @activity
  end

  def update
    if @activity
      @activity.update_attributes(sanitized_params)
      respond_with @activity
    end
  end

  def destroy
    @activity.destroy if @activity
    respond_with @activity
  end

  private

    def load_resource
      @activity = current_event.activity(params[:id])
      render_404 unless @activity
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

    def render_404
      render nothing: true, status: 404 and return
    end
end
