# frozen_string_literal: true

class AttachmentUploader < CommonUploader
  encrypt unless Rails.env.test? || Rails.env.cucumber?
end
