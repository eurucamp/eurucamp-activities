class ImageUrlMustBeTextField < ActiveRecord::Migration
  def change
    change_column :activities, :image_url, :text
  end
end
