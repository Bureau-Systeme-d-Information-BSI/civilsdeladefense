class RemoveSpontaneousFromJobApplicationFileType < ActiveRecord::Migration[7.1]
  def change
    remove_column :job_application_file_types, :spontaneous, :boolean, null: false
  end
end
