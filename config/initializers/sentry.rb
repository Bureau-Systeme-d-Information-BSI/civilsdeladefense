# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.enabled_environments = %w[production]
  config.excluded_exceptions += ["ActionController::RoutingError", "ActiveRecord::RecordNotFound"]
  config.send_default_pii = true

  # Performance tracking:
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sampler = lambda do |context|
    true
  end
end
