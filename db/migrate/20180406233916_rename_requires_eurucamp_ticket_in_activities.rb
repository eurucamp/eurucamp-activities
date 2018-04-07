class RenameRequiresEurucampTicketInActivities < ActiveRecord::Migration[5.0]
  def change
    rename_column :activities, :requires_eurucamp_ticket, :requires_event_ticket
  end
end
