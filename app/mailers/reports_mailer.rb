# frozen_string_literal: true

class ReportsMailer < ApplicationMailer
  def daily_summary(administrator, data, service_name)
    @data = data
    subject = t(".subject", service_name: service_name)

    mail to: administrator.email, subject: subject
  end

  def employer_recruiter_daily_report
    @administrator = params[:administrator]
    @sections = EmployerRecruiterDailyReport.new(@administrator).sections
    @service_name = @administrator.organization.service_name

    mail to: @administrator.email, subject: t(".subject", service_name: @service_name)
  end
end
