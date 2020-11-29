# frozen_string_literal: true

class DocumentUploader < CommonUploader
  encrypt unless Rails.env.test? || Rails.env.cucumber?

  def content_type_whitelist
    %r{application/pdf}
  end
end
