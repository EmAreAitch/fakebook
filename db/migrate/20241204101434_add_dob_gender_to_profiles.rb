class AddDobGenderToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :dob, :date, null: false
    add_column :profiles, :gender, :integer, null: false
  end
end
