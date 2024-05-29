class CreateDrawbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :drawbacks, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
    add_index :drawbacks, :name, unique: true
    add_index :drawbacks, :position
  end
end
