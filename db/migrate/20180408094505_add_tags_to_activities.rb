class AddTagsToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :tags, :text, array: true
  end
end
