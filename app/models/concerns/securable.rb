module Securable
  extend ActiveSupport::Concern

  DELIVER_SECURED_CONTENT = ENV["DELIVER_SECURED_CONTENT"]

  included do
    mount_uploader :secured_content, DocumentUploader, mount_on: :secured_content_file_name

    after_commit -> { SecureContentJob.set(wait: 15.seconds).perform_later(id: id) },
      unless: -> { secured? },
      if: -> { content.present? && pdf? && ENV.fetch("SECURE_CONTENT", false) }
  end

  def document_content
    return secured_content if DELIVER_SECURED_CONTENT && secured_content.present?
    content.presence
  end

  def secured?
    secured_content.present?
  end

  def secure_content!
    return if secured? || content.blank? || !pdf?
    return if (images = convert_original_content_to_images).empty?

    secured_filename = content.filename
    PdfUtils.convert_images_to_pdf(images, secured_filename)
    self.secured_content = File.open(secured_filename)
    save(validate: false)

    PdfUtils.delete_files([secured_filename] + images)
  end

  private

  def convert_original_content_to_images
    original_filename = content.filename.parameterize
    original_file = download(original_filename, content.read)
    image_filenames = PdfUtils.convert_pdf_file_to_images(original_file)
    original_file.close
    PdfUtils.delete_files([original_filename])
    image_filenames
  end

  def download(file_path, content)
    FileUtils.mkdir_p(File.dirname(file_path))
    file = File.open(file_path, "w+")
    file.write(content.force_encoding("UTF-8"))
    file.close
    file
  end

  def pdf?
    content.content_type == "application/pdf"
  rescue # Outscale failure: sometimes getting the content_type throws an error, because the file is not there
    false
  end
end
