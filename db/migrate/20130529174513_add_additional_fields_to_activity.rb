class AddAdditionalFieldsToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :anytime, :boolean, default: false
    add_column :activities, :requirements, :text
  end
end
