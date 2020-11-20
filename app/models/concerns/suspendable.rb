# frozen_string_literal: true

# Suspension management for User
module Suspendable
  extend ActiveSupport::Concern

  included do
    before_destroy :prevent_deletion_when_suspended
  end

  def suspended?
    self.suspended_at?
  end

  def suspend!(reason = nil)
    return if suspended?
    self.suspended_at = Time.zone.now
    self.suspension_reason = reason
    self.save(validate: false)
  end

  def unsuspend!
    return if !suspended?
    self.suspended_at = nil
    self.suspension_reason = nil
    self.save(validate: false) if self.changed?
  end


  def active_for_authentication?
    super && !suspended?
  end

  private

  def prevent_deletion_when_suspended
    if suspended?
      throw :abort
    end
  end
end
