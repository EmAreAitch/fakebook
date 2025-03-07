class CreatePostTimelines < ActiveRecord::Migration[8.0]
  def change
    create_table :post_timelines do |t|
      t.string :topics, array: true, default: []
      t.integer :counter, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
