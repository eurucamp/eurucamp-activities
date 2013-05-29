class StartTimeCanBeNull < ActiveRecord::Migration
  def change
    change_column :activities, :start_time, :datetime, null: true
  end
end
