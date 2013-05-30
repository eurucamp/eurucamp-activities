class SetAnytimeToTrueByDefault < ActiveRecord::Migration
  def change
    change_column :activities, :antyime, boolean, default: true, null: false
  end
end
