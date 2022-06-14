# frozen_string_literal: true

# Job offer state actions metaprogrammed from the array of state names
module SentryIdentifier
  extend ActiveSupport::Concern

  included do
    after_action :identify_to_sentry
  end

  private

  def identify_to_sentry
    identified = current_user.presence || current_administrator.presence
    Sentry.set_user(id: identified&.id, email: identified&.email, ip_address: request.ip)
  end
end
