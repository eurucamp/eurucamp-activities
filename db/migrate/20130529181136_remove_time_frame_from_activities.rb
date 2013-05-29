class RemoveTimeFrameFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :time_frame
  end
end
