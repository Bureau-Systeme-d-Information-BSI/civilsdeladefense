# frozen_string_literal: true

module JobApplication::Readable
  extend ActiveSupport::Concern

  def mark_all_as_read!
    emails.map(&:mark_as_read!)
    compute_notifications_counter!
  end
end
