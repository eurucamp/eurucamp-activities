class StartTimeCanBeNull < ActiveRecord::Migration[4.2]
  def change
    change_column :activities, :start_time, :datetime, null: true
  end
end
