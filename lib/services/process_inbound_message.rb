# frozen_string_literal: true

require "charlock_holmes"

# Inbound messages fetched from a IMAP mail server and then processed
class ProcessInboundMessage
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def call
    from = message[:from]
    to = message[:to]
    Rails.logger.info "InboundMessage treating message from #{from} to #{to}"
    original_email_id = fetch_original_email_id

    return false if original_email_id.blank?

    original_email = Email.find_by(id: original_email_id)

    return false if original_email.blank?
    return false if safe_body.blank?

    job_application = original_email.job_application
    sender_email = message.from.first
    user = User.find_by(email: sender_email)
    email = create_email(user, job_application, safe_body, message.subject)

    message.attachments.each do |attachment|
      email.email_attachments.create!(content: attachment.decoded)
    end

    true
  end

  private

  def safe_body
    return @safe_body if @safe_body

    body = message.multipart? ? multipart_body : message.decoded
    @safe_body = sanitize_and_encode(body)
    @safe_body
  end

  def multipart_body
    message.html_part&.body&.decoded || message.text_part&.body&.decoded
  end

  def sanitize_and_encode(body)
    body = Rails::Html::WhiteListSanitizer.new.sanitize(body)

    unless body.valid_encoding?
      detection = CharlockHolmes::EncodingDetector.detect(body)
      body = body.encode("UTF-8", detection[:ruby_encoding])
    end
    body
  end

  def fetch_original_email_id
    fetch_id_in_to || fetch_id_in_headers
  end

  def fetch_id_in_to
    message.to.map { |to| to.split(/\+(.*)@/)[1] }.compact.first
  end

  def fetch_id_in_headers
    ActiveSupport::Deprecation.warn("Old method to retreive mail id")
    references = message.header["References"]
    message_id_parent = references&.value
    message_id_parent&.scan(/<(.*)@/)&.flatten&.first
  end

  def create_email(user, job_application, body, subject)
    Audited.audit_class.as_user(user) do
      job_application.emails.create!(
        subject: subject, body: body, sender: user,
        created_at: message.date, updated_at: message.date
      )
    end
  end
end
