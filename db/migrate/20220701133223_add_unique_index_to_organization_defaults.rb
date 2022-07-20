class AddUniqueIndexToOrganizationDefaults < ActiveRecord::Migration[6.1]
  def change
    add_index :organization_defaults, [:kind, :organization_id], unique: true
  end
end
