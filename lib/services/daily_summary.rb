# frozen_string_literal: true

# Generate daily sommmary email from Notification
class DailySummary
  def generate
    administrators = Administrator.joins(:notifications).where(
      notifications: {daily: false}
    )
    administrators.each do |administrator|
      NotificationsMailer.daily_summary(administrator).deliver_now
      administrator.notifications.update_all(daily: true)
    end
  end
end
