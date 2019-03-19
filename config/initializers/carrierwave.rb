CarrierWave.configure do |config|
  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false

  if Rails.env.test? or Rails.env.cucumber?
    config.enable_processing = false
  end

  if ENV['OS_AUTH_URL']
    config.fog_provider = 'fog/openstack'
    config.fog_credentials = {
      provider:               'OpenStack',
      openstack_auth_url:      ENV['OS_AUTH_URL'],
      openstack_username:      ENV['OS_USERNAME'],
      openstack_api_key:       ENV['OS_PASSWORD'],
      openstack_region:        ENV['OS_REGION_NAME'],
      openstack_tenant:        ENV['OS_TENANT_NAME'],
      openstack_temp_url_key:  ENV['OS_TEMP_URL_KEY'],
      openstack_identity_api_version: 'v2.0'
    }
    config.fog_directory = ENV['BUCKET_NAME']
    config.fog_public = false
    config.storage = :fog
  else
    config.storage = :file
  end
end
