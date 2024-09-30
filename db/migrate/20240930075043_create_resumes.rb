class CreateResumes < ActiveRecord::Migration[7.1]
  def change
    create_table :resumes, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.string :content_file_name

      t.timestamps
    end
  end
end
