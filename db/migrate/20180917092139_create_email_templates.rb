class CreateEmailTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :email_templates, id: :uuid do |t|
      t.string :title
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
