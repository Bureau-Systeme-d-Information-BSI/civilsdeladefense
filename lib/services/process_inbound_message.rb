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
    create_email(user, job_application, safe_body, message.subject)

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
    current_organization = Organization.first
    if current_organization.inbound_email_config_catch_all?
      fetch_id_in_to
    elsif current_organization.inbound_email_config_hidden_headers?
      fetch_id_in_headers
    end
  end

  def fetch_id_in_to
    message.to.map { |to| to.split(/\+(.*)@/)[1] }.compact.first
  end

  def fetch_id_in_headers
    references = message.header["References"]
    message_id_parent = references&.value
    message_id_parent&.scan(/<(.*)@/)&.flatten&.first
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
