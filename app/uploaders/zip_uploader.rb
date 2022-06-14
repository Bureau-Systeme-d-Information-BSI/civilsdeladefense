# frozen_string_literal: true

class ZipUploader < CommonUploader
  def content_type_allowlist
    %r{application/zip}
  end

  def extension_allowlist
    %w[zip]
  end

  def store_dir
    "public/zip_files"
  end
end
