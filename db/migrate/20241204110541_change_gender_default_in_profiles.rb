class ChangeGenderDefaultInProfiles < ActiveRecord::Migration[8.0]
  def change
    change_column_default :profiles, :gender, 0
  end
end
