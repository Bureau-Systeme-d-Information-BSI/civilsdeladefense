# frozen_string_literal: true

# Inbound messages fetched from a IMAP mail server and then processed
class InboundMessage
  def self.fetch_and_process
    outgoing_mail_uri = URI(ENV['MAIL_URL'])
    user_name = CGI.unescape(outgoing_mail_uri.user)
    password = CGI.unescape(outgoing_mail_uri.password)
    host = outgoing_mail_uri.host

    Mail.defaults do
      retriever_method(
        :imap,
        address: host,
        port: 993,
        enable_ssl: true,
        user_name: user_name,
        password: password
      )
    end

    Mail.find(count: 100) do |message, imap, uid|
      to_be_trashed = ApplicantNotificationsMailer.receive(message)

      next unless to_be_trashed

      from = message[:from]
      to = message[:to]
      Rails.logger.debug "Message from #{from} to #{to} will be trashed"
      imap.uid_move(uid, ENV['MAIL_FOLDER_TRASH'])
    end
  end
end
