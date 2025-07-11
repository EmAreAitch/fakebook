class ChangeBotColumnNullToFalseOnBotRequests < ActiveRecord::Migration[8.0]
  def change
    change_column_null :bot_requests, :bot_id, true
  end
end
