# frozen_string_literal: true

class CreateCmgs < ActiveRecord::Migration[6.0]
  def change
    create_table :cmgs, id: :uuid do |t|
      t.string :email
      t.references :organization, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
