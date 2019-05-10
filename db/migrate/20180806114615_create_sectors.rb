# frozen_string_literal: true

class CreateSectors < ActiveRecord::Migration[5.2]
  def change
    create_table :sectors do |t|
      t.string :name

      t.timestamps
    end
    add_index :sectors, :name, unique: true
  end
end
