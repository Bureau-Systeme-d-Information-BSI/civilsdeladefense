# frozen_string_literal: true

class AddEncryptedFileTransferInError < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :encrypted_file_transfer_in_error, :boolean, default: false
    add_column :job_application_files, :encrypted_file_transfer_in_error, :boolean, default: false
  end
end
