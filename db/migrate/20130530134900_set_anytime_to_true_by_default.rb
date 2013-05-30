class SetAnytimeToTrueByDefault < ActiveRecord::Migration
  def change
    change_column :activities, :anytime, :boolean, default: true, null: false
  end
end
