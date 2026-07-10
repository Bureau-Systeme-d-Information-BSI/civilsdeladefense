# frozen_string_literal: true

CarrierWave.configure do |config|
  config.ignore_integrity_errors = true
  config.ignore_processing_errors = true
  config.ignore_download_errors = true

  config.enable_processing = false if Rails.env.test? || Rails.env.cucumber? # rubocop:disable Rails/UnknownEnv

  osc = Rails.application.credentials.osc
  if osc&.ak && !(Rails.env.test? || Rails.env.cucumber?) # rubocop:disable Rails/UnknownEnv
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: osc.ak,
      aws_secret_access_key: osc.sk,
      region: osc.region,
      endpoint: osc.endpoint,
      aws_signature_version: 2
    }
    config.fog_directory = osc.bucket
    config.fog_public = false
    config.storage = :fog
  else
    config.storage = :file
  end
end
