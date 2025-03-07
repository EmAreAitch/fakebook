class CreateInterestRelations < ActiveRecord::Migration[8.0]
  def change
    create_table :interest_relations do |t|
      t.references :interest, null: false, foreign_key: true
      t.references :interestable, polymorphic: true, null: false
      t.float :weight, default: 1

      t.timestamps
    end
  end
end
