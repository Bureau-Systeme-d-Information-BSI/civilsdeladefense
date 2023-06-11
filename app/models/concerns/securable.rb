module Securable
  extend ActiveSupport::Concern

  included do
    mount_uploader :secured_content, DocumentUploader, mount_on: :secured_content_file_name

    after_commit -> { SecureContentJob.set(wait: 1.minute).perform_later(id: id) },
      unless: -> { secured? },
      if: -> { content.present? && pdf? }
  end

  def document_content
    return secured_content if secured_content.present?
    return content if content.present?
  end

  def secured?
    secured_content.present?
  end

  def secure_content!(density: 300)
    return if secured? || content.blank? || !pdf?
    return if (images = convert_original_content_to_images(density)).empty?

    secured = convert_images_to_pdf(images)
    update!(secured_content: secured)
    secured.close
    File.delete(secured.path)
  end

  private

  def convert_original_content_to_images(density)
    original_filename = content.filename
    original_file = download(original_filename, content.read)
    image_filenames = convert_to_images(original_file, density)
    original_file.close
    File.delete(original_filename)
    image_filenames
  end

  def download(file_path, content)
    FileUtils.mkdir_p(File.dirname(file_path))
    file = File.open(file_path, "w+")
    file.write(content.force_encoding("UTF-8"))
    file.close
    file
  end

  def convert_to_images(pdf_file, density)
    image = MiniMagick::Image.open(pdf_file.path)
    image.pages.each_with_index { |page, index| convert_page_with_mini_magick(page.path, index, density) }
    Dir.entries(".").select { _1.start_with?("secured-image-") }.sort
  end

  def convert_page_with_mini_magick(page_path, index, density)
    MiniMagick::Tool::Convert.new do |convert|
      convert << "-quality" << "100"
      convert << "-density" << density.to_s
      convert << page_path
      convert << "secured-image-#{id}-#{index.to_s.rjust(5, "0")}.jpg"
    end
  rescue # sometimes the page is not convertable
    nil
  end

  def convert_images_to_pdf(image_filenames)
    secured_filename = content.filename
    MiniMagick::Tool::Convert.new do |convert|
      image_filenames.each { convert << _1 }
      convert << secured_filename
    end
    delete_files(image_filenames)
    File.open(secured_filename)
  end

  def delete_files(filenames)
    filenames.select { File.exist?(_1) }.each { File.delete(_1) }
  end

  def pdf?
    content.content_type == "application/pdf"
  rescue # sometimes getting the content_type throws an error, because the file is not there
    false
  end
end
