class AddSecuredContentFileNameToEmailAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :email_attachments, :secured_content_file_name, :string
  end
end
