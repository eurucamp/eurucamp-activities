class RemoveTimeFrameFromActivities < ActiveRecord::Migration[4.2]
  def change
    remove_column :activities, :time_frame
  end
end
