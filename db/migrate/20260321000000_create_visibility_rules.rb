# frozen_string_literal: true

class CreateVisibilityRules < ActiveRecord::Migration[7.1]
  def change
    create_table :visibility_rules, id: :uuid do |t|
      t.references :job_application_file_type, null: false, foreign_key: true, type: :uuid
      t.string :by, null: false, default: "administrator"
      t.integer :state, null: false, default: 0 # initial
      t.timestamps
    end
  end
end
