# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/applicant_notifications
class ApplicantNotificationsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/applicant_notifications/new_email
  def new_email
    ApplicantNotificationsMailer.new_email
  end
end
