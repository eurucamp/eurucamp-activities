class ParticipationsCountCantBeNull < ActiveRecord::Migration
  def change
    change_column(:activities, :participations_count, :integer, default: 0, null: false)
  end
end
