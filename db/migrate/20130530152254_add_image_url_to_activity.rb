class AddImageUrlToActivity < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :image_url, :string
  end
end
