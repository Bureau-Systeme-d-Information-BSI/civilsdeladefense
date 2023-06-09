namespace :migrate_data do
  task secure_job_application_files: :environment do
    secure_contents(JobApplicationFile)
  end

  task secure_email_attachments: :environment do
    secure_contents(EmailAttachment)
  end

  private

  def secure_contents(model)
    entries = model.where(secured_content_file_name: nil)
    Rails.logger.info("Migration start for #{entries.count} entries")

    entries.find_each do |securable|
      Rails.logger.info("Securing #{securable.id}")
      securable.secure_content!
    end

    Rails.logger.info("All done!")
  end
end
