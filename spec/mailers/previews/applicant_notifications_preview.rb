# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/applicant_notifications
class ApplicantNotificationsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/applicant_notifications/new_email
  delegate :new_email, to: :ApplicantNotificationsMailer

  def notify_new_state
    ApplicantNotificationsMailer.with(
      user: User.first,
      job_offer: JobOffer.first,
      state: "phone_meeting"
    ).notify_new_state
  end

  def notify_new_documents
    ApplicantNotificationsMailer.with(
      user: User.first,
      job_offer: JobOffer.first,
      document_names: ["CV", "Lettre de motivation", "Justificatif de domicile"]
    ).notify_new_documents
  end

  def notify_rejected
    ApplicantNotificationsMailer.with(
      user: User.first,
      job_offer: JobOffer.first
    ).notify_rejected
  end

  def notify_withdrawn
    ApplicantNotificationsMailer.with(
      user: User.first,
      job_offer: JobOffer.first
    ).notify_withdrawn
  end

  def deletion_warning
    ApplicantNotificationsMailer.with(user: User.first).deletion_warning
  end

  def deletion_canceled
    ApplicantNotificationsMailer.with(user: User.first).deletion_canceled
  end

  def deletion_notice
    user = User.first
    ApplicantNotificationsMailer.with(
      email: user.email,
      full_name: user.full_name,
      organization_id: user.organization_id
    ).deletion_notice
  end
end
