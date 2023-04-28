class DropAdminEmails < ActiveRecord::Migration[7.0]
  def change
    drop_table :admin_emails
  end
end
