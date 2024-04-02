class AddPositionIndexToForeignLanguageLevel < ActiveRecord::Migration[7.1]
  def change
    add_index :foreign_language_levels, :position
  end
end
