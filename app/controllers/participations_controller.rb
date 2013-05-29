class ParticipationsController < ApplicationController
  respond_to :json

  def create
    participation = current_activity.new_participation(current_user)
    participation.save
    respond_with(current_activity, participation)
  end

  def destroy
    participation = current_activity.participation(current_user)
    participation.destroy if participation && participation.participant == current_user #TODO
    respond_with(current_activity, participation)
  end

  private

    def current_activity
      @current_activity ||= current_event.activity(params[:activity_id])
    end

end
