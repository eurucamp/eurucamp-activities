class RenamePlaceToLocation < ActiveRecord::Migration
  def change
    rename_column :activities, :place, :location
  end
end
