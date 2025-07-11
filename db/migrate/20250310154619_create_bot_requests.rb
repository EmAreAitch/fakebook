class CreateBotRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :bot_requests do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :bot, null: false, foreign_key: { to_table: :users }
      t.string :tags, array: true, null: false

      t.timestamps
    end
  end
end
