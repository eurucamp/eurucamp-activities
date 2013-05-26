class ActivitiesController < ApplicationController
  respond_to :json, :html

  def index
    @activities = current_event.activities
    respond_with(@activities)
  end
end
