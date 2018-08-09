class CreateEmployers < ActiveRecord::Migration[5.2]
  def change
    create_table :employers do |t|
      t.string :name

      t.timestamps
    end
    add_index :employers, :name, unique: true
  end
end
