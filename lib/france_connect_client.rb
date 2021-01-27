# frozen_string_literal: true

# Retrieve user informations via FranceConnect
class FranceConnectClient
  def self.options
    Devise.omniauth_configs[:france_connect].options[:client_options]
  end

  def self.end_session_endpoint
    URI::HTTP.build(host: options[:host], path: options[:end_session_endpoint]).to_s
  end

  def initialize(code)
    @client = OpenIDConnect::Client.new(FranceConnectClient.options)
    @client.authorization_code = code
  end

  def user_info
    @client.access_token!(client_auth_method: :secret).userinfo!.raw_attributes
  end
end
