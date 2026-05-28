module PdfUtils
  class << self
    def convert_pdf_file_to_images(pdf_file, density = 150)
      image = MiniMagick::Image.open(pdf_file.path)
      prefix = SecureRandom.base36
      image.pages.each_with_index { |page, index| PdfUtils.convert_pdf_page_to_image(prefix, page.path, index, density) }
      Dir.entries(".").select { it.start_with?(prefix) }.sort
    rescue # ImageMagick failure: sometimes the pdf can't be opened
      []
    end

    def convert_pdf_page_to_image(image_filename_prefix, page_path, index, density)
      MiniMagick::Tool::Convert.new do |convert|
        convert << "-quality" << "100"
        convert << "-density" << density.to_s
        convert << "-alpha" << "remove"
        convert << "-background" << "white"
        convert << "-flatten"
        convert << page_path
        convert << "#{image_filename_prefix}-#{index.to_s.rjust(5, "0")}.png"
      end
    end

    def convert_images_to_pdf(image_filenames, filename)
      MiniMagick::Tool::Convert.new do |convert|
        image_filenames.each { convert << it }
        convert << filename
      end
    end

    def delete_files(filenames)
      filenames.select { File.exist?(it) }.each { File.delete(it) }
    end
  end
end
