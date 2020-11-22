# frozen_string_literal: true

# Suspension management for User
module Suspendable
  extend ActiveSupport::Concern

  included do
    before_destroy :prevent_deletion_when_suspended, prepend: true
    before_destroy :purge_associated_objects
  end

  def suspended?
    suspended_at?
  end

  def suspend!(reason = nil)
    return if suspended?

    self.suspended_at = Time.zone.now
    self.suspension_reason = reason
    save(validate: false)
  end

  def unsuspend!
    return unless suspended?

    self.suspended_at = nil
    self.suspension_reason = nil
    save(validate: false) if changed?
  end

  def active_for_authentication?
    super && !suspended?
  end

  private

  def prevent_deletion_when_suspended
    return unless suspended?

    errors.add(:base, :not_allowed_because_suspended)
    throw :abort
  end

  def purge_associated_objects
    job_applications.each do |job_application|
      job_application.emails.destroy_all
      job_application.messages.destroy_all
      job_application.job_application_files.destroy_all
    end
  end
end
