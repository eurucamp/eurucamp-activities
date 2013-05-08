class AddOauthHandlersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_handle, :string
    add_column :users, :github_handle, :string
  end
end
