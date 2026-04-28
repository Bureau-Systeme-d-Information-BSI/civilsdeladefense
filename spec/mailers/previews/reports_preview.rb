# frozen_string_literal: true

class ReportsPreview < ActionMailer::Preview
  def daily_summary = ReportsMailer.daily_summary

  def employer_recruiter_daily_report
    administrator = Administrator.employer_recruiters.first || Administrator.first
    ReportsMailer.with(administrator:).employer_recruiter_daily_report
  end
end
