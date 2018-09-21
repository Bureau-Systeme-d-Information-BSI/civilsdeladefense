require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Civilsdeladefense
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = 'Paris'

    config.i18n.available_locales = [:fr]
    config.i18n.default_locale = :fr

    if ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present? && ENV['AWS_REGION'].present? && ENV['AWS_BUCKET_NAME'].present?
      config.paperclip_defaults = {
        storage: :s3,
        bucket: ENV['AWS_BUCKET_NAME'],
        s3_region: ENV['AWS_REGION'],
        s3_credentials: {
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        }
      }
    end

    if Rails.env.production?
      # Cache assets for 1 year
      config.public_file_server.headers = {
        'Cache-Control' => "max-age=#{ 1.week.to_i }",
        'Expires' => 1.week.from_now.httpdate
      }

      # Setup HSTS to ensure https
      config.force_ssl = true
      config.ssl_options = { hsts: { subdomains: false, preload: true, expires: 1.year } }
    end

    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r301 /^\/administrators\/(.*)/, '/admin/$1'
    end

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
