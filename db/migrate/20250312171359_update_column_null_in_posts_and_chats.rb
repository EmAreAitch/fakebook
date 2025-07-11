class UpdateColumnNullInPostsAndChats < ActiveRecord::Migration[8.0]
  def change
    change_column_null(:posts, :content, false)
    change_column_null(:messages, :content, false)
  end
end
