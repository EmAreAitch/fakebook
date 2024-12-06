class AddUniqueIndexToLikes < ActiveRecord::Migration[8.0]
  def change
    add_index :likes, [:post_id, :user_id], unique: true
  end
end
