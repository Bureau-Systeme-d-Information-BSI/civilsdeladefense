# frozen_string_literal: true

# Base mailer class
class ApplicationMailer < ActionMailer::Base
  default from: CGI.unescape(URI(ENV['MAIL_URL']).user)
  layout 'mailer'
end
