class ParticipationsController < ApplicationController
  respond_to :js, :html

  def create
    unless current_activity.full?
      @participation = current_activity.new_participation(current_user)
      @participation.save
    end

    respond_with(current_activity.reload, @participation) do |format|
      format.html { redirect_back(fallback_location: activity_url(current_activity)) }
    end
  end

  def destroy
    @participation = current_activity.participation(current_user)
    authorize @participation
    @participation.destroy
    respond_with(current_activity.reload, @participation, location: request.referer)
  end

  private

  def current_activity
    @current_activity ||= current_event.activity(params[:activity_id]).try(:decorate)
  end
end
