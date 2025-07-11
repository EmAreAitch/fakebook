class UpdateUserIndexToUniqueInPostTimelines < ActiveRecord::Migration[8.0]
  def change
    remove_index :post_timelines, :user_id
    add_index :post_timelines, :user_id, unique: true
  end
end
