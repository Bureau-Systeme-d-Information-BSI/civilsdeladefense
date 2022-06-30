# frozen_string_literal: true

module SentryIdentifier
  extend ActiveSupport::Concern

  included do
    before_action :identify_to_sentry
  end

  private

  def identify_to_sentry
    identified = current_user.presence || current_administrator.presence
    Sentry.set_user(id: identified&.id, email: identified&.email, ip_address: request.ip)
  end
end
