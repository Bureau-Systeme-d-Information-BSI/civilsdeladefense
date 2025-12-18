class AddToStateToJobApplicationFileTypes < ActiveRecord::Migration[7.1]
  def change = add_column :job_application_file_types, :to_state, :integer, default: 11 # affected
end
