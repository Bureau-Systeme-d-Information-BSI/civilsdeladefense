# frozen_string_literal: true

class CreateBenefits < ActiveRecord::Migration[6.0]
  def change
    create_table :benefits, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
    add_index :benefits, :position

    add_reference :job_offers, :benefit, type: :uuid
  end
end
