namespace :migrate_data do
  task secure_contents: :environment do
    job_application_files = JobApplicationFile.where(secured_content_file_name: nil)

    Rails.logger.info("Migration start for #{job_application_files.count} job application files")

    job_application_files.find_each do |job_application_file|
      Rails.logger.info("Securing job application file #{job_application_file.id}")
      job_application_file.secure_content!
    end

    Rails.logger.info("All done!")
  end
end
