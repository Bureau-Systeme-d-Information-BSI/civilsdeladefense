# frozen_string_literal: true

# Base mailer class
class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM'] # was CGI.unescape(URI(ENV['MAIL_URL']).user)
  layout 'mailer'
end
