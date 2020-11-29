# frozen_string_literal: true

require 'charlock_holmes'

# Mail sent to candidate
class ApplicantNotificationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.applicant_notifications_mailer.new_email.subject
  #
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
    @site_name = @organization.name

    @email.attachments.each do |attachment|
      attachments[attachment.filename.to_s] = attachment.blob.download
    end

    reply_to = nil
    if @organization.inbound_email_config_catch_all?
      default_from = ENV['DEFAULT_FROM']
      reply_to = default_from.gsub('@', "+#{@email.id}@")
    elsif @organization.inbound_email_config_hidden_headers?
      mail_uri = URI(ENV['SMTP_URL'])
      host = mail_uri.host
      headers['Message-ID'] = "<#{@email.id}@#{host}>"
    end

    mail to: to, subject: subject, reply_to: reply_to
  end

  def receive(message)
    from = message[:from]
    to = message[:to]
    Rails.logger.debug "InboundMessage treating message from #{from} to #{to}"
    original_email_id = fetch_original_email_id(message)

    return false if original_email_id.blank?

    original_email = Email.find_by(id: original_email_id)

    return false if original_email.blank?

    body = mail_body(message)
    safe_body = Rails::Html::WhiteListSanitizer.new.sanitize(body)
    unless safe_body.valid_encoding?
      detection = CharlockHolmes::EncodingDetector.detect(safe_body)
      corrected_encoding = detection[:ruby_encoding]
      safe_body = safe_body.encode('UTF-8', corrected_encoding)
    end

    return false if safe_body.blank?

    job_application = original_email.job_application
    sender_email = message.from.first
    user = User.find_by_email sender_email
    create_email(user, job_application, safe_body, message.subject)

    true
  end

  def notice_period_before_deletion(user_id)
    @user = User.find(user_id)
    organization = @user.organization
    @site_name = organization.name
    @nbr_days_notice_period_before_deletion = ENV['NBR_DAYS_NOTICE_PERIOD_BEFORE_DELETION'].to_i

    to = @user.email
    subject = "[#{@site_name}] Votre compte candidat : mise à jour nécessaire"

    mail to: to, subject: subject
  end

  def deletion_notice(user_email, user_full_name, organization_id)
    @user_full_name = user_full_name
    organization = Organization.find(organization_id)
    @site_name = organization.name

    to = user_email
    subject = "[#{@site_name}] Votre compte candidat a été supprimé"

    mail to: to, subject: subject
  end

  protected

  def mail_body(message)
    @mail_body ||= begin
      body = message.multipart? ? message.parts[0].body.decoded : message.decoded
      body
    end
  end

  def fetch_original_email_id(message)
    current_organization = Organization.first
    if current_organization.inbound_email_config_catch_all?
      recipient = message[:to].to_s
      recipient.split(/\+(.*)@/)[1]
    elsif current_organization.inbound_email_config_hidden_headers?
      references = message.header['References']
      message_id_parent = references&.value
      message_id_parent&.scan(/<(.*)@/)&.flatten&.first
    end
  end

  def create_email(user, job_application, body, subject)
    Audited.audit_class.as_user(user) do
      email_params = {
        subject: subject,
        body: body
      }
      email = job_application.emails.build(email_params)
      email.created_at = email.updated_at = message.date
      email.sender = user
      email.job_application = job_application
      email.save!
    end
  end
end
