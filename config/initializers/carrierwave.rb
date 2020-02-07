# frozen_string_literal: true

CarrierWave.configure do |config|
  config.ignore_integrity_errors = true
  config.ignore_processing_errors = true
  config.ignore_download_errors = true

  config.enable_processing = false if Rails.env.test? || Rails.env.cucumber?

  if ENV['OSC_AK']
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['OSC_AK'],
      aws_secret_access_key: ENV['OSC_SK'],
      region: ENV['OSC_REGION'],
      endpoint: ENV['OSC_ENDPOINT'],
      aws_signature_version: 2
    }
    config.fog_directory = ENV['OSC_BUCKET']
    config.fog_public = false
    config.storage = :fog
  else
    config.storage = :file
  end
end
