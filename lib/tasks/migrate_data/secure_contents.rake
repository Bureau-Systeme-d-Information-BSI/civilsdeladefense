namespace :migrate_data do
  task secure_job_application_files: :environment do
    secure_contents(JobApplicationFile)
  end

  task secure_email_attachments: :environment do
    secure_contents(EmailAttachment)
  end

  desc "Convert all PDF files (in the current directory) to images and back to PDF to secure them"
  task convert: :environment do
    Dir.entries(".").select { _1.end_with?(".pdf") }.map { File.open(_1) }.each do |pdf|
      puts "Converting #{pdf.path}"
      images = PdfUtils.convert_pdf_file_to_images(pdf)
      PdfUtils.convert_images_to_pdf(images, "converted_#{pdf.path}")
      PdfUtils.delete_files(images)
    end
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
