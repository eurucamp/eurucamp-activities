class AddRequiresEurucampTicketToActivities < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :requires_eurucamp_ticket, :boolean, null: false, default: false
  end
end
