# frozen_string_literal: true

class AttachmentUploader < CommonUploader
  encrypt unless Rails.env.test? || Rails.env.cucumber? # rubocop:disable Rails/UnknownEnv
end
