class CreateLevel < ActiveRecord::Migration[7.1]
  def change
    create_table :levels, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_index :levels, :position
    add_index :levels, :name, unique: true
  end
end
