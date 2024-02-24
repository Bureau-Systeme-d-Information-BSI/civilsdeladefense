# frozen_string_literal: true

# Deactivation management of administrators
module DeactivationFlow
  extend ActiveSupport::Concern

  # Deactivation management class method
  module ClassMethods
    def deactivate_when_too_old!
      deactivate_admins!(inactive_and_marked_for_deactivation_admins)
      deactivate_admins!(never_signed_in_and_marked_for_deactivation_admins)
      mark_admins_for_deactivation!(inactive_and_not_marked_for_deactivation_admin)
      mark_admins_for_deactivation!(never_signed_in_and_not_marked_for_deactivation_admins)
    end

    private

    def deactivate_admins!(scope) = scope.find_each { deactivate_admin!(_1) }

    def mark_admins_for_deactivation!(scope) = scope.find_each { mark_admin_for_deactivation!(_1) }

    def deactivate_admin!(administrator)
      administrator.deactivate
      DeactivationMailer.notice(administrator).deliver_now
    end

    def mark_admin_for_deactivation!(administrator)
      administrator.mark_for_deactivation!
      DeactivationMailer.period_before(administrator).deliver_now
    end

    def inactive_and_marked_for_deactivation_admins
      where("marked_for_deactivation_on < ?", days_notice_period_before_deactivation.days.ago.to_date)
        .where("last_sign_in_at < ?", days_inactivity_period_before_deactivation.days.ago)
    end

    def never_signed_in_and_marked_for_deactivation_admins
      where("marked_for_deactivation_on < ?", days_notice_period_before_deactivation.days.ago.to_date)
        .where(last_sign_in_at: nil)
        .where("created_at < ?", days_inactivity_period_before_deactivation.days.ago)
    end

    def inactive_and_not_marked_for_deactivation_admin
      where("last_sign_in_at < ?", notice_period_target_date)
        .where(marked_for_deactivation_on: nil)
    end

    def never_signed_in_and_not_marked_for_deactivation_admins
      where(last_sign_in_at: nil)
        .where(marked_for_deactivation_on: nil)
        .where("created_at < ?", notice_period_target_date)
    end

    def notice_period_target_date
      (days_inactivity_period_before_deactivation - days_notice_period_before_deactivation).days.ago
    end

    def days_inactivity_period_before_deactivation = ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DEACTIVATION"].to_i

    def days_notice_period_before_deactivation = ENV["DAYS_NOTICE_PERIOD_BEFORE_DEACTIVATION"].to_i
  end

  def mark_for_deactivation! = update_column(:marked_for_deactivation_on, Time.zone.now.to_date) # rubocop:disable Rails/SkipsModelValidations

  def active? = deleted_at.blank?

  def inactive? = deleted_at.present?

  def deactivate = update_attribute(:deleted_at, Time.current) # rubocop:disable Rails/SkipsModelValidations

  def reactivate = update_attribute(:deleted_at, nil) # rubocop:disable Rails/SkipsModelValidations
end
