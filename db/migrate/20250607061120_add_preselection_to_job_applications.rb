class AddPreselectionToJobApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :job_applications, :preselection, :integer, default: 0
  end
end
