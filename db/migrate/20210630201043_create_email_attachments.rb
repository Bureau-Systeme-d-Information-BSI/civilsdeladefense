class CreateEmailAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :email_attachments, id: :uuid do |t|
      t.references :email, null: false, foreign_key: true, type: :uuid
      t.string :content

      t.timestamps
    end

    remove_column :emails, :attachments, :json
  end
end
