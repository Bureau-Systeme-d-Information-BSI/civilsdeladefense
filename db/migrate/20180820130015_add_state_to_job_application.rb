class AddStateToJobApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :job_applications, :state, :string

    JobApplication.update_all state: :initial

    add_index :job_applications, :state
  end
end
