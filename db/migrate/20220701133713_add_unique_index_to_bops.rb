class AddUniqueIndexToBops < ActiveRecord::Migration[6.1]
  def change
    add_index :bops, :name, unique: true
  end
end
