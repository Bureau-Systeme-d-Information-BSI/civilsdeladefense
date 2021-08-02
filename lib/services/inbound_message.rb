# frozen_string_literal: true

# Inbound messages fetched from a IMAP mail server and then processed
class InboundMessage
  def self.fetch_and_process
    config = retriever_method_configuration

    Mail.defaults do
      retriever_method(*config)
    end

    Mail.all do |message, imap, uid|
      valid = ProcessInboundMessage.new(message).call

      from = message[:from]
      to = message[:to]

      if !valid
        Rails.logger.info "Message from #{from} to #{to} is invalid"
        ApplicantNotificationsMailer.error_email(from.to_s, message[:subject].to_s).deliver_now
      end
      if ENV["MAIL_FOLDER_TRASH"].present?
        Rails.logger.info "Message from #{from} to #{to} will be trashed"
        imap.uid_move(uid, ENV["MAIL_FOLDER_TRASH"])
      end
    end
  end

  def self.retriever_method_configuration
    mail_uri = URI(ENV["MAIL_URL"])
    user_name = CGI.unescape(mail_uri.user)
    password = CGI.unescape(mail_uri.password)
    host = mail_uri.host
    port = mail_uri.port
    scheme = mail_uri.scheme
    protocol = :imap if /imap/.match?(scheme)
    protocol = :pop if /pop/.match?(scheme)

    config = {
      address: host,
      port: port,
      enable_ssl: true,
      user_name: user_name,
      password: password
    }

    [protocol.to_sym, config]
  end
end
