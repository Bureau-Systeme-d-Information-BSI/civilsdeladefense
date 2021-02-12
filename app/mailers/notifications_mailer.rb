# frozen_string_literal: true

# Periodic notifications mailer
class NotificationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.daily_summary.subject
  #
  def daily_summary(administrator, data, service_name)
    @data = data
    subject_with_org = t('notifications_mailer.daily_summary.subject', service_name: service_name)

    mail to: administrator.email, subject: subject_with_org
  end
end
