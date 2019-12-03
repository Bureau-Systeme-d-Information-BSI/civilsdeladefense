# frozen_string_literal: true

class DocumentUploader < CommonUploader
  encrypt

  def content_type_whitelist
    %r{application/pdf}
  end
end
