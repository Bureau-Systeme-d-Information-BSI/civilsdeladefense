# frozen_string_literal: true

# Mail sent to candidate
class ApplicantNotificationsMailer < ApplicationMailer
  def new_email(email_id)
    @email = Email.find email_id
    @job_application = @email.job_application
    @job_offer = @job_application.job_offer
    @organization = @job_offer.organization
    @user = @job_application.user

    to = @user.email
    subject = @email.subject
    @body = @email.body
    @answer_url = account_job_applications_url
    @service_name = @organization.service_name

    @email.email_attachments.each do |attachment|
      attachments[attachment.document_content.filename.to_s] = attachment.document_content.read
    end

    reply_to = nil
    if @organization.inbound_email_config_catch_all?
      default_from = ENV["DEFAULT_FROM"]
      reply_to = default_from.gsub("@", "+#{@email.id}@")
    end

    mail to: to, subject: subject, reply_to: reply_to
  end

  def error_email(to, original_subject)
    @service_name = Organization.first.service_name
    @original_subject = original_subject
    @full_name = User.find_by(email: to)&.full_name

    mail to: to, subject: "[#{@service_name}]"
  end

  def notice_period_before_deletion(user_id)
    @user = User.find(user_id)
    @service_name = @user.organization.service_name
    @days_notice_period_before_deletion = ENV["DAYS_NOTICE_PERIOD_BEFORE_DELETION"].to_i

    to = @user.email
    subject = "[#{@service_name}] Votre compte candidat : mise à jour nécessaire"

    mail to: to, subject: subject
  end

  def deletion_notice(user_email, user_full_name, organization_id)
    @user_full_name = user_full_name
    organization = Organization.find(organization_id)
    @service_name = organization.service_name

    to = user_email
    subject = "[#{@service_name}] Votre compte candidat a été supprimé"

    mail to: to, subject: subject
  end

  def send_job_offer(user, job_offer)
    return unless user.receive_job_offer_mails

    @user = user
    @job_offer = job_offer

    @service_name = @user.organization.service_name

    mail to: @user.email, subject: t(".subject")
  end
end
