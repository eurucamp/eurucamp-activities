class AddAdditionalInformationToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :additional_information, :jsonb, null: false, default: {}
  end
end
