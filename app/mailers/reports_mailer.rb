# frozen_string_literal: true

class ReportsMailer < ApplicationMailer
  def daily_summary(administrator, data, service_name)
    @data = data
    subject = t(".subject", service_name: service_name)

    mail to: administrator.email, subject: subject
  end

  def employer_recruiter_daily_report
    @administrator = params[:administrator]
    @sections = Reports::Daily.new(@administrator).sections
    @service_name = @administrator.organization.service_name

    mail to: @administrator.email, subject: t(".subject", service_name: @service_name)
  end

  def employment_authority_weekly_report
    @administrator = params[:administrator]
    @sections = Reports::Weekly.new(@administrator).sections
    @service_name = @administrator.organization.service_name
    @week_starts_on = 1.week.ago.beginning_of_week.to_date

    mail to: @administrator.email, subject: t(".subject", service_name: @service_name)
  end
end
