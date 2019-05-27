# frozen_string_literal: true

class AddFieldsToAdministrators < ActiveRecord::Migration[5.2]
  def change
    add_column :administrators, :title, :string
    add_column :administrators, :employer_id, :uuid
    add_column :administrators, :role, :integer
    rename_column :administrators, :name, :first_name
    add_column :administrators, :last_name, :string

    add_index :administrators, :employer_id

    add_foreign_key :administrators, :employers
  end
end
