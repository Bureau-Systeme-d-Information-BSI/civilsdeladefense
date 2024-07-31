class AddUniquenessIndexOnNameToAvailabilityRange < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    remove_index :availability_ranges, :name
    add_index :availability_ranges, :name, unique: true, algorithm: :concurrently
  end

  def down
    remove_index :availability_ranges, :name
    add_index :availability_ranges, :name, algorithm: :concurrently
  end
end
