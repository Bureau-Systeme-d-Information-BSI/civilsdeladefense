namespace :migrate_data do
  task secure_job_application_files: :environment do
    secure_contents(JobApplicationFile)
  end

  task secure_email_attachments: :environment do
    secure_contents(EmailAttachment)
  end

  desc "Convert all PDF files (in the current directory) to images and back to PDF to secure them"
  task convert: :environment do
    Dir.entries(".").select { _1.end_with?(".pdf") }.map { File.open(_1) }.each do |pdf_file|
      puts "Converting #{pdf_file.path}"
      images = convert_to_images(pdf_file, 150) # TODO SEB: density?
      convert_images_to_pdf("converted_#{pdf_file.path}", images)
      delete_files(images)
    end
  end

  private

  def secure_contents(model)
    entries = model.where(secured_content_file_name: nil)
    Rails.logger.info("Migration start for #{entries.count} entries")

    entries.find_each do |securable|
      Rails.logger.info("Securing #{securable.id}")
      securable.secure_content!
    rescue # if image magick fails because the image quality is to high, try again with lower density
      securable.secure_content!(density: 150)
    end

    Rails.logger.info("All done!")
  end

  def convert_to_images(pdf_file, density)
    id = pdf_file.path.parameterize
    image = MiniMagick::Image.open(pdf_file.path)
    image.pages.each_with_index { |page, index| convert_page_with_mini_magick(id, page.path, index, density) }
    Dir.entries(".").select { _1.start_with?("secured-image-#{id}-") }.sort
  end

  # TODO SEB: move to a util module
  def convert_page_with_mini_magick(id, page_path, index, density)
    MiniMagick::Tool::Convert.new do |convert|
      convert << "-quality" << "100"
      convert << "-density" << density.to_s
      convert << "-alpha" << "remove" # TODO SEB: remove alpha
      convert << "-background" << "white" # TODO SEB: background
      convert << "-flatten" # TODO SEB: flatten
      convert << page_path
      convert << "secured-image-#{id}-#{index.to_s.rjust(5, "0")}.png" # TODO SEB: PNG to keep size low
    end
  end

  def convert_images_to_pdf(secured_filename, image_filenames)
    MiniMagick::Tool::Convert.new do |convert|
      image_filenames.each { convert << _1 }
      convert << secured_filename
    end
  end

  def delete_files(filenames)
    filenames.select { File.exist?(_1) }.each { File.delete(_1) }
  end
end
