class CreateCategoryExperienceLevels < ActiveRecord::Migration[7.1]
  def change
    create_table :category_experience_levels, id: :uuid do |t|
      t.references :category, null: false, foreign_key: true, type: :uuid
      t.references :experience_level, null: false, foreign_key: true, type: :uuid
      t.references :profile, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
