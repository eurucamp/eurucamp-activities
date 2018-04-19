class CreateParticipations < ActiveRecord::Migration[4.2]
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :activity_id

      t.timestamps
    end

    add_column :activities, :participations_count, :integer, default: 0
  end
end
