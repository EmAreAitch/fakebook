class AddTypeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :type, :string, default: "User", null: false
  end
end
