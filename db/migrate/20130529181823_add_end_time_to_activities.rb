class AddEndTimeToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :end_time, :datetime
  end
end
