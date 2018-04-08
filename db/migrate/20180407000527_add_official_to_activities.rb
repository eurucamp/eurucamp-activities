class AddOfficialToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :official, :boolean, null: false, default: false
  end
end
