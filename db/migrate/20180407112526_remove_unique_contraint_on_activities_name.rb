class RemoveUniqueContraintOnActivitiesName < ActiveRecord::Migration[5.0]
  def change
    remove_index :activities, column: :name
    add_index :activities, :name, unique: false
  end
end
