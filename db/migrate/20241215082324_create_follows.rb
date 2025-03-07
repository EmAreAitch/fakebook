class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }
      t.integer :status, default: 0

      t.timestamps
    end

    # Add a unique index to prevent duplicate follow requests
    add_index :follows, [:follower_id, :followed_id], unique: true
  end
end