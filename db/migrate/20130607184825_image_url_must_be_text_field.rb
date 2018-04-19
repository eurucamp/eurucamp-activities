class ImageUrlMustBeTextField < ActiveRecord::Migration[4.2]
  def change
    change_column :activities, :image_url, :text
  end
end
