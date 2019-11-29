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
  elsif ENV['OS_AUTH_URL']
    config.fog_provider = 'fog/openstack'
    config.fog_credentials = {
      provider: 'OpenStack',
      openstack_auth_url: ENV['OS_AUTH_URL'],
      openstack_username: ENV['OS_USERNAME'],
      openstack_api_key: ENV['OS_PASSWORD'],
      openstack_region: ENV['OS_REGION_NAME'],
      openstack_tenant: ENV['OS_TENANT_NAME'],
      openstack_temp_url_key: ENV['OS_TEMP_URL_KEY'],
      openstack_identity_api_version: 'v2.0'
    }
    config.fog_directory = ENV['BUCKET_NAME']
    config.fog_public = false
    config.storage = :fog
  else
    config.storage = :file
  end
end
