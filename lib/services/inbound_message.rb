# frozen_string_literal: true

# Inbound messages fetched from a IMAP mail server and then processed
class InboundMessage
  def self.fetch_and_process
    config = retriever_method_configuration
    Mail.defaults do
      retriever_method(*config)
    end

    Mail.all do |message, imap, uid|
      to_be_trashed = ProcessInboundMessage.new(message).call

      from = message[:from]
      to = message[:to]
      if to_be_trashed && ENV["MAIL_FOLDER_TRASH"].present?
        Rails.logger.info "Message from #{from} to #{to} will be trashed"
        imap.uid_move(uid, ENV["MAIL_FOLDER_TRASH"])
      elsif ENV["MAIL_FOLDER_ARCHIVE"].present?
        Rails.logger.info "Message from #{from} to #{to} will be archived"
        imap.uid_move(uid, ENV["MAIL_FOLDER_ARCHIVE"])
      end
    end
  end

  def self.retriever_method_configuration
    outgoing_mail_uri = URI(ENV["MAIL_URL"])
    user_name = CGI.unescape(outgoing_mail_uri.user)
    password = CGI.unescape(outgoing_mail_uri.password)
    host = outgoing_mail_uri.host
    port = outgoing_mail_uri.port
    scheme = outgoing_mail_uri.scheme
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
