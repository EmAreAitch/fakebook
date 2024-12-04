class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.text :bio, null: false, limit: 250
      t.string :country
      t.string :city
      t.string :profession
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
