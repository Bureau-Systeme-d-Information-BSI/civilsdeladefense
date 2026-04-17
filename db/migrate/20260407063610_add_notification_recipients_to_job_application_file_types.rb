class AddNotificationRecipientsToJobApplicationFileTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :job_application_file_types, :notify_user, :boolean, default: false, null: false
    add_column :job_application_file_types, :notify_employer_recruiter, :boolean, default: false, null: false
    add_column :job_application_file_types, :notify_employment_authority, :boolean, default: false, null: false
    add_column :job_application_file_types, :notify_hr_manager, :boolean, default: false, null: false
    add_column :job_application_file_types, :notify_payroll_manager, :boolean, default: false, null: false
  end
end
