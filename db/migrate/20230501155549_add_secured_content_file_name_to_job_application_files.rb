class AddSecuredContentFileNameToJobApplicationFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :job_application_files, :secured_content_file_name, :string
  end
end
