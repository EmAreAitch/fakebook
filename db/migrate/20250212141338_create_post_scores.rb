class CreatePostScores < ActiveRecord::Migration[8.0]
  def change
    create_view :post_scores, materialized: true
    add_index :post_scores, [ :user_id, :post_id ], unique: true, name: 'idx_post_scores_user_post'
  end
end
