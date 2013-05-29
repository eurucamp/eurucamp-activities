class ParticipationsController < ApplicationController
  respond_to :js, :html

  def create
    participation = current_activity.new_participation(current_user)
    participation.save
    respond_with(current_activity.reload, participation, location: activities_path)
  end

  def destroy
    participation = current_activity.participation(current_user)
    participation.destroy if participation && participation.participant == current_user #TODO
    respond_with(current_activity.reload, participation, location: activities_path)
  end

  private

    def current_activity
      @current_activity ||= current_event.activity(params[:activity_id]).decorate
    end

end
