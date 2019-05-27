# frozen_string_literal: true

class CreateStudyLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :study_levels do |t|
      t.string :name

      t.timestamps
    end
    add_index :study_levels, :name, unique: true
  end
end
