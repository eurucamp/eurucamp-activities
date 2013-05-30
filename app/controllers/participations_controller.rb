class ParticipationsController < ApplicationController
  respond_to :js, :html

  before_filter :load_resource
  authorize_resource only: :destroy

  def create
    @participation.save
    respond_with(current_activity.reload, @participation, location: activities_path)
  end

  def destroy
    @participation.destroy
    respond_with(current_activity.reload, @participation, location: activities_path)
  end

  private

    def load_resource
      @participation = current_activity.new_participation(current_user)
    end

    def current_activity
      @current_activity ||= current_event.activity(params[:activity_id]).decorate
    end

end
