class AddFollowersFollowingsCountToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :followers_count, :integer, default: 0, null: false
    add_column :users, :followings_count, :integer, default: 0, null: false
  end
end
