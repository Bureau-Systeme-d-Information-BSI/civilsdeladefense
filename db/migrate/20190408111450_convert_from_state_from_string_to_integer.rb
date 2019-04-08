class ConvertFromStateFromStringToInteger < ActiveRecord::Migration[5.2]
  def change
    rename_column :job_application_file_types, :from_state, :old_from_state
    add_column :job_application_file_types, :from_state, :integer

    JobApplicationFileType.all.each do |entry|
      entry.from_state = JobApplication.states[ entry.old_from_state ]
      entry.save!
    end
  end
end
