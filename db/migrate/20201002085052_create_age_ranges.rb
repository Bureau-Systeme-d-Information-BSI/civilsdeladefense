# frozen_string_literal: true

class CreateAgeRanges < ActiveRecord::Migration[6.0]
  def change
    create_table :age_ranges, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.index :name
      t.index :position

      t.timestamps
    end

    add_reference :profiles, :age_range, type: :uuid, foreign_key: true

    AgeRange.create(name: "18 - 20 ans")
    AgeRange.create(name: "20 - 30 ans")
    AgeRange.create(name: "30 - 40 ans")
    AgeRange.create(name: "40 - 50 ans")
    AgeRange.create(name: "50 - 60 ans")
    AgeRange.create(name: "60 ans et +")
  end
end
