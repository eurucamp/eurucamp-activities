class AddShowParticipation < ActiveRecord::Migration[4.2]
  def change
    add_column :users, 'show_participation', :boolean, null: false, default: true
  end
end
