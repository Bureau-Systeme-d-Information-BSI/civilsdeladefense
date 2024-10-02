class CreateDepartmentProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :department_profiles, id: :uuid do |t|
      t.references :department, null: false, foreign_key: true, type: :uuid
      t.references :profile, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
