class AddAttachmentsToEmails < ActiveRecord::Migration[6.1]
  def change
    add_column :emails, :attachments, :json
  end
end
