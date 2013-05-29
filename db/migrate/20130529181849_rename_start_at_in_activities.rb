class RenameStartAtInActivities < ActiveRecord::Migration
  def change
    rename_column :activities, :start_at, :start_time
  end
end
