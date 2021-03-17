class AddNotificationToJobApplicationFileType < ActiveRecord::Migration[6.1]
  def change
    add_column :job_application_file_types, :notification, :boolean, default: true
  end
end
