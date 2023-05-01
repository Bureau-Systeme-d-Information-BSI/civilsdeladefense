module JobApplicationFile::Securable
  extend ActiveSupport::Concern

  included do
    mount_uploader :secured_content, DocumentUploader, mount_on: :secured_content_file_name

    after_commit -> { SecureContentJob.perform_later(id: id) }, unless: -> { secured? }
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
    content_file_name
  end

  def secured_file_path
    "secured_#{original_file_path}"
  end

  def download(file_path, content)
    FileUtils.mkdir_p(File.dirname(file_path))
    file = File.open(file_path, "w+")
    file.write(content.force_encoding("UTF-8"))
    file.close
    file
  end

  def convert_to_images(pdf_file)
    system("pdftoppm", pdf_file.path, "page", "-png")
    Dir.entries(".").select { _1.start_with?("page-") }.sort
  end

  def convert_to_pdf(image_file_names, file_path)
    system("img2pdf", *image_file_names, "-o", file_path)
  end

  def delete_files(file_names)
    # file_names.select { File.exist?(_1) }.each { File.delete(_1) }
  end
end
