# frozen_string_literal: true

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

    mail_uri = URI(ENV['SMTP_URL'])
    host = mail_uri.host

    @email.attachments.each do |attachment|
      attachments[attachment.filename.to_s] = attachment.blob.download
    end

    reply_to = nil
    if @organization.inbound_email_config_catch_all?
      default_from = ENV['DEFAULT_FROM']
      reply_to = default_from.gsub('@', "+#{@email.id}@")
    elsif @organization.inbound_email_config_hidden_headers?
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

    body = (message.text_part || message.html_part || message).body.decoded
    body = ActionView::Base.full_sanitizer.sanitize(body)

    return false if body.blank?

    job_application = original_email.job_application
    sender_email = message.from.first
    user = User.find_by_email sender_email
    create_email(user, job_application, body, message.subject)

    true
  end

  protected

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
