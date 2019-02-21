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
    @user = @job_application.user

    to = @user.email
    subject = @email.subject
    @body = @email.body
    @answer_url = account_job_applications_url

    mail_uri = URI(ENV['MAIL_URL'])
    host = mail_uri.host
    headers['Message-ID'] = "<#{ @email.id }@#{ host }>"

    @email.attachments.each do |attachment|
      attachments[attachment.filename.to_s] = attachment.blob.download
    end

    mail to: to, subject: subject
  end

  def receive(message)
    references = message.header['References']
    original_email_id = references.value.split(/\<(.*)@/)[1]
    Rails.logger.debug "InboundMessage treating message #{message.inspect}"
    if original_email_id.present?
      begin
        original_email = Email.find original_email_id
      rescue ActiveRecord::RecordNotFound => e
        original_email = nil
      end
      if original_email.blank?
        return false
      end
      body = (message.text_part || message.html_part || message).body.decoded
      body = ActionView::Base.full_sanitizer.sanitize(body)
      if body.present?
        job_application = original_email.job_application
        subject = message.subject
        sender_email = message.from.first
        user = User.find_by_email sender_email
        email_params = {
          subject: subject,
          body: body
        }
        email = job_application.emails.build(email_params)
        email.created_at = email.updated_at = message.date
        email.sender = user
        email.job_application = job_application
        email.save!
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
