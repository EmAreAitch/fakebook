class UpdateDefaultWeightForInterestRelations < ActiveRecord::Migration[8.0]
  def change
    change_column_default :interest_relations, :weight, 0.5
  end
end
