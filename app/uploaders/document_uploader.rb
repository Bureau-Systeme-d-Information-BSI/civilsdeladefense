class DocumentUploader < CommonUploader
  def content_type_whitelist
    /application\/pdf/
  end
end
