class ApplicationMailer < ActionMailer::Base
  default from: URI.unescape(URI(ENV['MAIL_URL']).user)
  layout 'mailer'
end
