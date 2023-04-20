class CreateAdminEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_emails, id: :uuid do |t|
      t.string :email
      t.string :service_name
      t.text :data

      t.timestamps
    end

    add_index :admin_emails, :email
  end
end
