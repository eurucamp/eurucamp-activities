class CreateActivities < ActiveRecord::Migration[4.2]
  def change
    create_table :activities do |t|
      t.string :name, null: false, default: ''
      t.text :description
      t.string :place
      t.timestamp :start_at, null: false
      t.integer :time_frame
      t.integer :limit_of_participants

      t.timestamps
    end

    add_index :activities, :name, unique: true
  end
end
