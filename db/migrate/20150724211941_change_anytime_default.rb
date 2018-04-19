class ChangeAnytimeDefault < ActiveRecord::Migration[4.2]
  def up
    change_column_default :activities, :anytime, false
  end

  def down
    change_column_default :activities, :anytime, true
  end
end
