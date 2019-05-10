# frozen_string_literal: true

class CreateOfficialStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :official_statuses do |t|
      t.string :name

      t.timestamps
    end
    add_index :official_statuses, :name, unique: true
  end
end
