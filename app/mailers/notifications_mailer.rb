# frozen_string_literal: true

# Periodic notifications mailer
class NotificationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.daily_summary.subject
  #
  def daily_summary(administrator, data)
    @data = data

    mail to: administrator.email
  end
end
