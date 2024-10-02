class AddResumeFileNameToProfiles < ActiveRecord::Migration[7.1]
  def change = add_column :profiles, :resume_file_name, :string
end
