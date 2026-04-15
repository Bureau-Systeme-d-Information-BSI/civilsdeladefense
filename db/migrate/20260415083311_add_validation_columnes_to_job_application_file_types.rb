class AddValidationColumnesToJobApplicationFileTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :job_application_file_types, :validate_by_employer_recruiter, :boolean, default: false, null: false
    add_column :job_application_file_types, :validate_by_employment_authority, :boolean, default: false, null: false
    add_column :job_application_file_types, :validate_by_hr_manager, :boolean, default: false, null: false
    add_column :job_application_file_types, :validate_by_payroll_manager, :boolean, default: false, null: false
  end
end
