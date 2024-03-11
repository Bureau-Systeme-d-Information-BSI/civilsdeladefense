# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Civilsdeladefense
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # No longer add autoloaded paths into `$LOAD_PATH`. This means that you won't be able
    # to manually require files that are managed by the autoloader, which you shouldn't do anyway.
    #
    # This will reduce the size of the load path, making `require` faster if you don't use bootsnap, or reduce the size
    # of the bootsnap cache if you use it.
    config.add_autoload_paths_to_load_path = false

    config.eager_load_paths << Rails.root.join("lib/services")
    config.eager_load_paths << Rails.root.join("lib/renderers")
    config.autoload_paths << Rails.root.join("extras")

    config.time_zone = "Paris"

    config.i18n.available_locales = [:fr]
    config.i18n.default_locale = :fr

    # Sanitizer
    config.action_view.sanitized_allowed_tags = ActionView::Base.sanitized_allowed_tags + [
      "align-left",
      "align-center",
      "align-right",
      "align-justify"
    ]

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
  end
end
