# Preview all emails at http://localhost:3000/rails/mailers/notifications
class NotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifications/daily_summary
  def daily_summary
    NotificationsMailer.daily_summary
  end

end
