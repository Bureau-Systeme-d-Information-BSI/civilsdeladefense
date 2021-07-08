# frozen_string_literal: true

# Inbound messages fetched from a IMAP mail server and then processed
class InboundMessage
  def self.fetch_and_process
    organization = Organization.first
    retriever_conf = retriever_method_configuration
    delivery_conf = delivery_method_configuration

    Mail.defaults do
      retriever_method(*retriever_conf)
      delivery_method(*delivery_conf)
    end

    Mail.all do |message, imap, uid|
      to_be_trashed = ProcessInboundMessage.new(message).call

      from = message[:from]
      to = message[:to]

      if to_be_trashed && ENV["MAIL_FOLDER_TRASH"].present?
        Rails.logger.info "Message from #{from} to #{to} will be trashed"
        imap.uid_move(uid, ENV["MAIL_FOLDER_TRASH"])
      else
        if ENV["MAIL_FOLDER_ARCHIVE"].present?
          Rails.logger.info "Message from #{from} to #{to} will be archived"
          imap.uid_move(uid, ENV["MAIL_FOLDER_ARCHIVE"])
        end
        if ENV["MAIL_TRANSFER"].present?
          Rails.logger.info "Message from #{from} to #{to} will be transfered to #{ENV["MAIL_TRANSFER"]}"
          transfer_message = message.dup
          transfer_message[:to] = ENV["MAIL_TRANSFER"]
          transfer_message[:subject] = "Fwd[#{organization.service_name}]: #{transfer_message[:subject]}"
          transfer_message.deliver!
        end
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

  def self.delivery_method_configuration
    mail_uri = URI(ENV["SMTP_URL"])
    user_name = CGI.unescape(mail_uri.user)
    password = CGI.unescape(mail_uri.password)
    host = mail_uri.host
    port = mail_uri.port
    scheme = mail_uri.scheme

    config = {
      address: host,
      port: port,
      enable_ssl: true,
      user_name: user_name,
      password: password
    }

    [scheme, config]
  end
end
