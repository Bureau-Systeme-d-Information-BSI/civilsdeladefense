# frozen_string_literal: true

class CreateOrganizationDefaults < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_defaults, id: :uuid do |t|
      t.text :value
      t.integer :kind, index: true
      t.references :organization, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
