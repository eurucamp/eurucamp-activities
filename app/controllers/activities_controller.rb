class ActivitiesController < ApiController
  respond_to :html

  include Yaks::Rails::ControllerAdditions

  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_filter :load_resource, only: [:show, :edit, :update, :destroy]
  authorize_resource only: [:edit, :update, :destroy]

  def index
    @activities = current_event.search_activities(current_user, query_params[:search], query_params[:filter])
    @counters = current_event.counters(current_user)
    yaks @activities, item_mapper: ActivityMapper
  end

  def show
    yaks @activity, mapper: ActivityMapper
  end

  def create
    @activity = current_event.new_activity(current_user, sanitized_params)
    if @activity.save
      yaks @activity.decorate, mapper: ActivityMapper, status: :created
    else
      render nothing: true, status: :bad_request
    end
  end

  def update
    if @activity
      if @activity.update_attributes(sanitized_params)
        yaks @activity, mapper: ActivityMapper
      else
        render nothing: true, status: :bad_request
      end
    end
  end

  def destroy
    @activity.destroy if @activity
    render nothing: true, status: :no_content
  end

  private

    def load_resource
      @activity = current_event.activity(params[:id]).try(:decorate)
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
