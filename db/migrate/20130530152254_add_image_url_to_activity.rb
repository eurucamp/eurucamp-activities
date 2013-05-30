class AddImageUrlToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :image_url, :string
  end
end
