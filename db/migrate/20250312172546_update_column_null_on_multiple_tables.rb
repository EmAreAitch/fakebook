class UpdateColumnNullOnMultipleTables < ActiveRecord::Migration[8.0]
  def change
    change_column_null :interest_relations, :weight, false
    change_column_null :follows, :status, false
    change_column_null :post_timelines, :topics, false
    change_column_null :post_timelines, :counter, false
  end
end
