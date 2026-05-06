class AddCoverLetterToJobApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :job_applications, :cover_letter_file_name, :string
  end
end
