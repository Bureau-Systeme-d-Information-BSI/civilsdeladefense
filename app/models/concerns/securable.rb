module Securable
  extend ActiveSupport::Concern

  included do
    mount_uploader :secured_content, DocumentUploader, mount_on: :secured_content_file_name

    after_commit -> { SecureContentJob.perform_later(id: id) }, unless: -> { secured? }
  end

  def document_content
    return secured_content if secured_content.present?
    return content if content.present?
  end

  def secured?
    secured_content.present?
  end

  def secure_content!
    return if secured? || content.blank?

    image_file_names = convert_to_images(download(original_file_path, content.read))

    convert_to_pdf(image_file_names, secured_file_path)

    update(secured_content: File.open(secured_file_path))

    delete_files(image_file_names + [original_file_path, secured_file_path])
  end

  private

  def original_file_path
    content.filename
  end

  def secured_file_path
    "secured-#{id}.pdf"
  end

  def download(file_path, content)
    FileUtils.mkdir_p(File.dirname(file_path))
    file = File.open(file_path, "w+")
    file.write(content.force_encoding("UTF-8"))
    file.close
    file
  end

  def convert_to_images(pdf_file)
    image = MiniMagick::Image.open(pdf_file.path)
    image.pages.each_with_index do |page, index|
      MiniMagick::Tool::Convert.new do |convert|
        convert << "-quality" << "100"
        convert << "-density" << "150"
        convert << page.path
        convert << "secured-image-#{id}-#{index}.jpg"
      end
    end
    Dir.entries(".").select { _1.start_with?("secured-image-") }.sort
  end

  def convert_to_pdf(image_file_names, file_path)
    MiniMagick::Tool::Convert.new do |convert|
      image_file_names.each { convert << _1 }
      convert << file_path
    end
  end

  def delete_files(file_names)
    file_names.select { File.exist?(_1) }.each { File.delete(_1) }
  end
end
