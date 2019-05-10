# frozen_string_literal: true

class DocumentUploader < CommonUploader
  def content_type_whitelist
    %r{application/pdf}
  end
end
