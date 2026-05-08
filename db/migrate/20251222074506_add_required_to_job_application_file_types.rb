class AddRequiredToJobApplicationFileTypes < ActiveRecord::Migration[7.1]
  def change = add_column :job_application_file_types, :required, :boolean, null: false, default: false
end
