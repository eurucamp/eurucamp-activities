class SetAnytimeToTrueByDefault < ActiveRecord::Migration[4.2]
  def change
    change_column :activities, :anytime, :boolean, default: true, null: false
  end
end
