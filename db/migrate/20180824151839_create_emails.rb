# frozen_string_literal: true

class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :title
      t.text :body
      t.references :job_application, foreign_key: true
      t.references :administrator, foreign_key: true

      t.timestamps
    end
  end
end
