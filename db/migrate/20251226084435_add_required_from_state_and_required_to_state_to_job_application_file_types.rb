class AddRequiredFromStateAndRequiredToStateToJobApplicationFileTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :job_application_file_types, :required_from_state, :integer, default: 0 # initial
    add_column :job_application_file_types, :required_to_state, :integer, default: 11 # affected
  end
end
