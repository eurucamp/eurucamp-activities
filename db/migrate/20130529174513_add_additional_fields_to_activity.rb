class AddAdditionalFieldsToActivity < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :anytime, :boolean, default: false
    add_column :activities, :requirements, :text
  end
end
