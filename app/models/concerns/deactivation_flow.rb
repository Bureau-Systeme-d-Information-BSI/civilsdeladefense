# frozen_string_literal: true

# Deactivation management of administrators
module DeactivationFlow
  extend ActiveSupport::Concern

  # Deactivation management class method
  module ClassMethods
    def deactivate_when_too_old
      target_date = days_notice_period_before_deactivation.days.ago.to_date
      where("marked_for_deactivation_on < ?", target_date)
        .where("last_sign_in_at < ?", days_inactivity_period_before_deactivation.days.ago)
        .find_each do |administrator|
          administrator.deactivate
          DeactivationMailer.notice(administrator).deliver_now
        end

      where("last_sign_in_at < ?", notice_period_target_date)
        .where(marked_for_deactivation_on: nil)
        .find_each do |administrator|
        administrator.mark_for_deactivation!
        DeactivationMailer.period_before(administrator).deliver_now
      end
    end

    def notice_period_target_date
      days_diff = days_inactivity_period_before_deactivation -
        days_notice_period_before_deactivation
      days_diff.days.ago
    end

    def days_inactivity_period_before_deactivation
      ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DEACTIVATION"].to_i
    end

    def days_notice_period_before_deactivation
      ENV["DAYS_NOTICE_PERIOD_BEFORE_DEACTIVATION"].to_i
    end
  end

  def mark_for_deactivation!
    update_column(:marked_for_deactivation_on, Time.zone.now.to_date)
  end

  def active?
    deleted_at.blank?
  end

  def inactive?
    deleted_at.present?
  end

  def deactivate
    update_attribute(:deleted_at, Time.current)
  end

  def reactivate
    update_attribute(:deleted_at, nil)
  end
end
