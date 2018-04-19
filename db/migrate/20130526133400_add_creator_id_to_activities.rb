class AddCreatorIdToActivities < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :creator_id, :integer
  end
end
