# frozen_string_literal: true

class CreateContractDurations < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_durations, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_index :contract_durations, :name, unique: true
    add_index :contract_durations, :position

    add_column :contract_types, :duration, :boolean, default: false

    add_reference :job_offers, :contract_duration, type: :uuid
  end
end
