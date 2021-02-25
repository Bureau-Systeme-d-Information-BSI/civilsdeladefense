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
      where("last_sign_in_at < ?", notice_period_target_date).all.each do |user|
        user.mark_for_deletion!
        ApplicantNotificationsMailer.notice_period_before_deletion(user.id).deliver_now
      end
      target_date = nbr_days_notice_period_before_deletion.days.ago.to_date
      where("marked_for_deletion_on < ?", target_date)
        .where("last_sign_in_at < ?", notice_period_target_date).all.each do |user|
        email = user.email
        name = user.full_name
        org_id = user.organization_id
        user.destroy
        ApplicantNotificationsMailer.deletion_notice(email, name, org_id).deliver_now
      end
    end

    def notice_period_target_date
      nbr_days_diff = nbr_days_inactivity_period_before_deletion -
        nbr_days_notice_period_before_deletion
      nbr_days_diff.days.ago
    end

    private

    def nbr_days_inactivity_period_before_deletion
      ENV["NBR_DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"].to_i
    end

    def nbr_days_notice_period_before_deletion
      ENV["NBR_DAYS_NOTICE_PERIOD_BEFORE_DELETION"].to_i
    end
  end

  def mark_for_deletion!
    update_column(:marked_for_deletion_on, Time.zone.now.to_date)
  end

  private

  def purge_associated_objects
    job_applications.reload.each do |job_application|
      job_application.emails.destroy_all
      job_application.messages.destroy_all
      job_application.job_application_files.destroy_all
    end
  end
end
