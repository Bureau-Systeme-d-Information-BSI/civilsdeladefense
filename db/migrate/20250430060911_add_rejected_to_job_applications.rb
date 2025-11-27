class AddRejectedToJobApplications < ActiveRecord::Migration[7.1]
  def change = add_column :job_applications, :rejected, :boolean, default: false
end
