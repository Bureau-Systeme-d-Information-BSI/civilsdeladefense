class AddUniqueIndexToJobApplicationFiles < ActiveRecord::Migration[6.1]
  def change
    add_index :job_application_files, [:job_application_file_type_id, :job_application_id], unique: true, name: :file_type_by_job_application_id
  end
end
