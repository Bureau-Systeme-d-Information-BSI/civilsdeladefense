# frozen_string_literal: true

class CreateBops < ActiveRecord::Migration[5.2]
  def change
    create_table :bops, id: :uuid do |t|
      t.string :name
      t.integer :position, index: true

      t.timestamps
    end
    add_reference :job_offers, :bop, type: :uuid, foreign_key: true

    add_column :rejection_reasons, :position, :integer
    add_index :rejection_reasons, :position
  end
end
