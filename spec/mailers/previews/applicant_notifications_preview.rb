# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/applicant_notifications
class ApplicantNotificationsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/applicant_notifications/new_email
  def new_email
    ApplicantNotificationsMailer.new_email
  end

  def notify_new_state
    ApplicantNotificationsMailer.with(
      user: User.first,
      job_offer: JobOffer.first,
      state: "phone_meeting"
    ).notify_new_state
  end

  def notify_rejected
    ApplicantNotificationsMailer.with(
      user: User.first,
      job_offer: JobOffer.first
    ).notify_rejected
  end
end
