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

  def send_job_offer(user, job_offer)
    return unless user.receive_job_offer_mails

    @user = user
    @job_offer = job_offer

    @service_name = @user.organization.service_name

    mail to: @user.email, subject: t(".subject")
  end

  def notify_new_state
    @user = params[:user]
    @job_offer = params[:job_offer]
    @state = JobApplication.human_attribute_name("state/#{params[:state]}")
    @service_name = @job_offer.organization.service_name

    mail to: @user.email, subject: t(
      ".subject",
      job_offer_identifier: @job_offer.identifier,
      service_name: @job_offer.organization.service_name
    )
  end

  def notify_new_documents
    @user = params[:user]
    @job_offer = params[:job_offer]
    @document_names = params[:document_names]
    @service_name = @job_offer.organization.service_name

    mail to: @user.email, subject: t(
      ".subject",
      job_offer_title: @job_offer.title,
      service_name: @service_name
    )
  end

  def notify_rejected
    @user = params[:user]
    @job_offer = params[:job_offer]
    @service_name = @job_offer.organization.service_name

    mail to: @user.email, subject: t(
      ".subject",
      job_offer_title: @job_offer.title,
      service_name: @service_name
    )
  end

  def notify_withdrawn
    @user = params[:user]
    @job_offer = params[:job_offer]
    @service_name = @job_offer.organization.service_name

    mail to: @user.email, subject: t(
      ".subject",
      job_offer_title: @job_offer.title,
      service_name: @service_name
    )
  end

  def deletion_warning
    @user = params[:user]
    @service_name = @user.organization.service_name
    @days_notice_period_before_deletion = User::Deletable::NOTICE_PERIOD.in_days.to_i

    mail to: @user.email, subject: t(".subject", service_name: @service_name)
  end
end
