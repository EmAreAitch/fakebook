class AddChatsConstraints < ActiveRecord::Migration[8.0]
  def up
    # Add a unique index using LEAST/GREATEST to ensure uniqueness regardless of order
    execute <<-SQL
      CREATE UNIQUE INDEX unique_conversations ON chats (
        LEAST(sender_id, receiver_id),
        GREATEST(sender_id, receiver_id)
      );
    SQL
    
    # Prevent self-messaging
    add_check_constraint :chats, "sender_id != receiver_id", name: "prevent_self_messages"
  end

  def down
    remove_index :chats, name: :unique_conversations
    remove_check_constraint :chats, name: :prevent_self_messages
  end
end
