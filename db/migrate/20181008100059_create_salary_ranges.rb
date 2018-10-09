class CreateSalaryRanges < ActiveRecord::Migration[5.2]
  def change
    create_table :salary_ranges, id: :uuid do |t|
      t.string :estimate_annual_salary_gross
      t.references :professional_category, type: :uuid, foreign_key: true
      t.references :experience_level, type: :uuid, foreign_key: true
      t.references :sector, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
