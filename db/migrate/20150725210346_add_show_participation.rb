class AddShowParticipation < ActiveRecord::Migration
  def change
    add_column :users, 'show_participation', :boolean, null: false, default: true
  end
end
