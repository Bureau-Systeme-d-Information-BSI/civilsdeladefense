# frozen_string_literal: true

class DocumentUploader < CommonUploader
  encrypt unless Rails.env.test? || Rails.env.cucumber? # rubocop:disable Rails/UnknownEnv

  def content_type_allowlist
    %r{application/pdf}
  end
end
