# frozen_string_literal: true

# Periodic notifications mailer
class NotificationsMailer < ApplicationMailer
  def daily_summary(administrator)
    @notifications = {}
    Notification::KINDS.each do |kind|
      @notifications[kind] = administrator.notifications.where(daily: false, kind: kind)
    end
    return if @notifications.values.all?(&:blank?)

    subject = t(".subject", service_name: Organization.first.service_name)

    mail to: administrator.email, subject: subject
  end
end
