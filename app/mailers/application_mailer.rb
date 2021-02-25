# frozen_string_literal: true

# Base mailer class
class ApplicationMailer < ActionMailer::Base
  default from: ENV["DEFAULT_FROM"]
  layout "mailer"
end
