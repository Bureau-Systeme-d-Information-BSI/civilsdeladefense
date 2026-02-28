# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifications
class NotificationsPreview < ActionMailer::Preview
  def new_email
    job_application = JobApplication.find_by(state: :phone_meeting) || JobApplication.first
    NotificationsMailer.with(administrator: Administrator.first, job_application:).new_email
  end

  def daily_summary = NotificationsMailer.daily_summary
end
