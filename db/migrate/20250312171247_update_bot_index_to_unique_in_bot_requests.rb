class UpdateBotIndexToUniqueInBotRequests < ActiveRecord::Migration[8.0]
  def change
    remove_index :bot_requests, :bot_id
    add_index :bot_requests, :bot_id, unique: true
  end
end
