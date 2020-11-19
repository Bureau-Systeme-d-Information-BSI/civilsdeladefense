# frozen_string_literal: true

# Suspension management for User
module Suspendable
  extend ActiveSupport::Concern

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
end
