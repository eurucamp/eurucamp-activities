class RenameStartAtInActivities < ActiveRecord::Migration[4.2]
  def change
    rename_column :activities, :start_at, :start_time
  end
end
