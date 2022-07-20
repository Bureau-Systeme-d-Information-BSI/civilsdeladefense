# frozen_string_literal: true

# Deletion management of users
module DeletionFlow
  extend ActiveSupport::Concern

  included do
    before_destroy :purge_associated_objects
  end

  # Deletion management class method
  module ClassMethods
    def destroy_when_too_old
      target_date = days_notice_period_before_deletion.days.ago.to_date
      where("marked_for_deletion_on < ?", target_date)
        .where("last_sign_in_at < ?", days_inactivity_period_before_deletion.days.ago)
        .find_each do |user|
          email = user.email
          name = user.full_name
          org_id = user.organization_id
          user.destroy
          ApplicantNotificationsMailer.deletion_notice(email, name, org_id).deliver_now
        end

      where("last_sign_in_at < ?", notice_period_target_date)
        .where(marked_for_deletion_on: nil)
        .find_each do |user|
          user.mark_for_deletion!
          ApplicantNotificationsMailer.notice_period_before_deletion(user.id).deliver_now
        end
    end

    def notice_period_target_date
      days_diff = days_inactivity_period_before_deletion -
        days_notice_period_before_deletion
      days_diff.days.ago
    end

    private

    def days_inactivity_period_before_deletion
      ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"].to_i
    end

    def days_notice_period_before_deletion
      ENV["DAYS_NOTICE_PERIOD_BEFORE_DELETION"].to_i
    end
  end

  def mark_for_deletion!
    update_column(:marked_for_deletion_on, Time.zone.now.to_date) # rubocop:disable Rails/SkipsModelValidations
  end

  private

  def purge_associated_objects
    job_applications.reload.each do |job_application|
      job_application.emails.destroy_all
      job_application.messages.destroy_all
      job_application.job_application_files.destroy_all
      job_application.compute_notifications_counter!
    end
  end
end
