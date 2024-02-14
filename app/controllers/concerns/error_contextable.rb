# frozen_string_literal: true

module ErrorContextable
  extend ActiveSupport::Concern

  included do
    before_action :set_error_context
  end

  private

  def set_error_context
    identified = current_user.presence || current_administrator.presence
    RorVsWild.merge_error_context(id: identified&.id, email: identified&.email, ip_address: request.ip)
  end
end
