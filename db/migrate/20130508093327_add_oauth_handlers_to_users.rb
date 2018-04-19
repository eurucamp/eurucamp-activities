class AddOauthHandlersToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :twitter_handle, :string
    add_column :users, :github_handle, :string
  end
end
