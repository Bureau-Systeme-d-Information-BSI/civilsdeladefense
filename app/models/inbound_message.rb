class InboundMessage
  def self.fetch_and_process
    outgoing_mail_uri = URI(ENV['MAIL_URL'])
    user_name = URI.unescape(outgoing_mail_uri.user)
    password = URI.unescape(outgoing_mail_uri.password)
    host = outgoing_mail_uri.host

    Mail.defaults do
      retriever_method(
        :pop3,
        address: host,
        port: 995,
        enable_ssl: true,
        user_name: user_name,
        password: password
      )
    end

    Mail.find_and_delete(count: 100).each do |message|
      ApplicantNotificationsMailer.receive(message)
    end
  end
end
