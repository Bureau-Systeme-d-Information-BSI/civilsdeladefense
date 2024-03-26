class AddUniquenessIndexToForeignLanguageLevel < ActiveRecord::Migration[7.1]
  def change
    add_index :foreign_language_levels, :name, unique: true
  end
end
