class ActsAsListIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :contract_types, :position
    add_index :experience_levels, :position
    add_index :professional_categories, :position
    add_index :sectors, :position
    add_index :study_levels, :position
  end
end
