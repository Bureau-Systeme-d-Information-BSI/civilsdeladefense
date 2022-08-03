# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Civilsdeladefense
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.time_zone = "Paris"

    config.i18n.available_locales = [:fr]
    config.i18n.default_locale = :fr

    config.autoload_paths << "#{Rails.root}/lib" # rubocop:disable Rails/FilePath

    if Rails.env.production?
      # Cache assets for 1 year
      config.public_file_server.headers = {
        "Cache-Control" => "max-age=#{1.year.to_i}",
        "Expires" => 1.year.from_now.httpdate
      }

      # Setup HSTS to ensure https
      config.force_ssl = true
      config.ssl_options = {hsts: {subdomains: false, preload: true, expires: 1.year}}
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "/offresdemploi.json", headers: :any, methods: %i[get options]
      end
    end

    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r301 %r{^/administrators/(.*)}, "/admin/$1"
    end

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.to_prepare do
      Devise::Mailer.layout "mailer"
    end

    config.eager_load_paths << Rails.root.join("lib/services")
    config.eager_load_paths << Rails.root.join("lib/renderers")
    config.autoload_paths << Rails.root.join("lib/services")
    config.autoload_paths << Rails.root.join("lib/renderers")

    config.active_job.queue_adapter = :sidekiq
  end
end
