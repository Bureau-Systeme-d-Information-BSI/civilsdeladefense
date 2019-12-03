# frozen_string_literal: true

class LegacyCommonUploader < CommonUploader
  # define some uploader specific configurations in the initializer
  # to override the global configuration
  def initialize(*)
    super

    self.fog_provider = 'fog/openstack'
    self.fog_credentials = {
      provider: 'OpenStack',
      openstack_auth_url: ENV['OS_AUTH_URL'],
      openstack_username: ENV['OS_USERNAME'],
      openstack_api_key: ENV['OS_PASSWORD'],
      openstack_region: ENV['OS_REGION_NAME'],
      openstack_tenant: ENV['OS_TENANT_NAME'],
      openstack_temp_url_key: ENV['OS_TEMP_URL_KEY'],
      openstack_identity_api_version: 'v2.0'
    }
    self.fog_directory = ENV['BUCKET_NAME']
    self.fog_public = false
  end
end
