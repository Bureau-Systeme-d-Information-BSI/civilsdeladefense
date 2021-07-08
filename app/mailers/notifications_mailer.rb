# frozen_string_literal: true

# Periodic notifications mailer
class NotificationsMailer < ApplicationMailer
  def daily_summary(administrator, data, service_name)
    @data = data
    subject = t(".subject", service_name: service_name)

    mail to: administrator.email, subject: subject
  end
end
