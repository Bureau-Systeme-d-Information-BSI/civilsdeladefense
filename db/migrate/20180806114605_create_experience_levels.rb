# frozen_string_literal: true

class CreateExperienceLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :experience_levels do |t|
      t.string :name

      t.timestamps
    end
    add_index :experience_levels, :name, unique: true
  end
end
