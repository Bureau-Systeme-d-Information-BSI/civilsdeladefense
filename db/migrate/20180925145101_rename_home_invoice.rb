# frozen_string_literal: true

class RenameHomeInvoice < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :home_invoice_file_name, :proof_of_address_file_name
    rename_column :users, :home_invoice_content_type, :proof_of_address_content_type
    rename_column :users, :home_invoice_file_size, :proof_of_address_file_size
    rename_column :users, :home_invoice_updated_at, :proof_of_address_updated_at
    rename_column :users, :home_invoice_is_validated, :proof_of_address_is_validated
  end
end
