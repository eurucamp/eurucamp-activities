class RenamePlaceToLocation < ActiveRecord::Migration[4.2]
  def change
    rename_column :activities, :place, :location
  end
end
