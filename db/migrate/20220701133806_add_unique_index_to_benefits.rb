class AddUniqueIndexToBenefits < ActiveRecord::Migration[6.1]
  def change
    add_index :benefits, :name, unique: true
  end
end
