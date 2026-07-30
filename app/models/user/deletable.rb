# frozen_string_literal: true

module User::Deletable
  extend ActiveSupport::Concern

  INACTIVITY_PERIOD = 12.months
  NOTICE_PERIOD = 30.days

  included do
    scope :long_time_unauthenticated, -> {
      where(marked_for_deletion_at: nil)
        .where(suspended_at: nil)
        .where(
          "last_sign_in_at < :cutoff OR (last_sign_in_at IS NULL AND created_at < :cutoff)",
          cutoff: INACTIVITY_PERIOD.ago
        )
    }
  end

  def mark_for_deletion!
    update_column(:marked_for_deletion_at, Time.current) # rubocop:disable Rails/SkipsModelValidations
    ApplicantNotificationsMailer.with(user: self).deletion_warning.deliver_later
  end

  def cancel_deletion!
    return if marked_for_deletion_at.nil?

    update_column(:marked_for_deletion_at, nil) # rubocop:disable Rails/SkipsModelValidations
    ApplicantNotificationsMailer.with(user: self).deletion_canceled.deliver_later
  end

  def after_database_authentication
    super
    cancel_deletion!
  end
end
