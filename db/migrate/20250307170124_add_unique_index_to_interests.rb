class AddUniqueIndexToInterests < ActiveRecord::Migration[8.0]
  def change
    change_column_null :interests, :name, false
    add_index :interests, :name, unique: true
  end
end
