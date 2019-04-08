class CreateJobApplicationFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :job_application_files, id: :uuid do |t|
      t.string :content_file_name
      t.integer :is_validated, limit: 2, default: 0
      t.references :job_application, type: :uuid, foreign_key: true
      t.references :job_application_file_type, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
