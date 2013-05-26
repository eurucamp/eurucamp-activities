class AddCreatorIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :creator_id, :integer
  end
end
