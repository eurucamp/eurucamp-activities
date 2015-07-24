class ChangeAnytimeDefault < ActiveRecord::Migration
  def up
    change_column_default :activities, :anytime, false
  end

  def down
    change_column_default :activities, :anytime, true
  end
end
