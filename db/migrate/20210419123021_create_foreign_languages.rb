class CreateForeignLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :foreign_languages, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    create_table :foreign_language_levels, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
    create_table :profile_foreign_languages, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.references :foreign_language, null: false, foreign_key: true, type: :uuid
      t.references :foreign_language_level, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
