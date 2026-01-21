class RemoveByDefaultFromJobApplicationFileTypes < ActiveRecord::Migration[7.1]
  def change = remove_column :job_application_file_types, :by_default, :boolean, default: false
end
