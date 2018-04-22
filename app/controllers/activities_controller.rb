class ActivitiesController < ApplicationController
  respond_to :html

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :load_and_authorize_activity, only: %i[show edit update destroy]

  def index
    @activities_per_day = current_event.activities_per_day(current_user, query_params[:search], query_params[:filter])
    @counters = current_event.counters(current_user)
    respond_with(@activities_per_day)
  end

  def show
    respond_with(@activity)
  end

  def new
    @activity = current_event.new_activity(current_user, {})
    authorize @activity
    respond_with(@activity)
  end

  def edit
    respond_with(@activity)
  end

  def create
    @activity = current_event.new_activity(current_user, sanitized_params)
    authorize @activity
    type        = @activity.save ? :notice : :error
    flash[type] = I18n.t("new_activity.#{type}")
    respond_with(@activity, location: activities_path)
  end

  def update
    if @activity
      type        = @activity.update(sanitized_params) ? :notice : :error
      flash[type] = I18n.t("edit_activity.#{type}")
    end
    respond_with(@activity, location: edit_activity_path(@activity))
  end

  def destroy
    if @activity && params[:confirm_delete] && @activity.destroy
      redirect_to root_path, notice: I18n.t('destroy_activity.notice')
    else
      flash[:error] = I18n.t('destroy_activity.error')
      render :edit
    end
  end

  private

  def load_and_authorize_activity
    @activity = current_event.activity(params[:id]) or
      raise(ActiveRecord::RecordNotFound)
    authorize @activity
    @activity = @activity.decorate
  end

  def sanitized_params
    params.require(:activity)
          .permit(:start_time,
                  :end_time,
                  :name,
                  :location,
                  :requirements,
                  :requires_event_ticket,
                  :description,
                  :limit_of_participants,
                  :anytime,
                  :image_url)
  end

  def query_params
    params.permit(:search, :filter)
  end
end
