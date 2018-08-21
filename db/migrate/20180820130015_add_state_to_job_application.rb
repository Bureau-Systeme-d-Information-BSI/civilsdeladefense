class AddStateToJobApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :job_applications, :state, :integer

    JobApplication.update_all state: 0

    add_index :job_applications, :state
  end
end
