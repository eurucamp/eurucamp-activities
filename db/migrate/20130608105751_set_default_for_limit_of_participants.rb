class SetDefaultForLimitOfParticipants < ActiveRecord::Migration
  def change
    change_column :activities, :limit_of_participants, :integer, default: 10
  end
end
