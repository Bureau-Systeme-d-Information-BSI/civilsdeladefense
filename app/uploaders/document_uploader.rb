# frozen_string_literal: true

class DocumentUploader < CommonUploader
  encrypt unless Rails.env.test? || Rails.env.cucumber? # rubocop:disable Rails/UnknownEnv

  def content_type_allowlist
    %r{application/pdf}
  end

  # Lockbox's CarrierWave extension defines #size as `read.bytesize`, which raises
  # when the underlying encrypted file is missing (read returns nil). counter_culture
  # dups the record after every update, and CarrierWave's #initialize_dup re-caches
  # the uploader — so any update! crashes when the file is gone.
  def size
    read&.bytesize || 0
  end
end
