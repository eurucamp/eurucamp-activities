class AddEndTimeToActivities < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :end_time, :datetime
  end
end
