# frozen_string_literal: true

require "clockwork"
require "./config/boot"
require "./config/environment"

# Clockwork/cron-like rules definition
module Clockwork
  error_handler do |error|
    RorVsWild.record_error(error)
  end

  configure do |config|
    config[:tz] = "Europe/Paris"
  end

  cond = ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"].present?
  cond &&= ENV["DAYS_NOTICE_PERIOD_BEFORE_DELETION"].present?
  if cond
    every 1.day, "purge_users", at: "11:00" do
      User::MarkForDeletionJob.perform_later
      User::DeleteOldJob.perform_later
    end
  end

  cond = ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DEACTIVATION"].present?
  cond &&= ENV["DAYS_NOTICE_PERIOD_BEFORE_DEACTIVATION"].present?
  if cond
    every 1.day, "purge_administrators", at: "11:00" do
      Administrator::DeactivateOldJob.perform_later
    end
  end

  if (ENV["SEND_DAILY_SUMMARY"] || ENV["CRON_DAILY_SUMMARY"]).present?
    every 1.day, "daily_summary", at: "08:00" do
      DailySummary.new(day: 1.day.ago).prepare_and_send
    end
  end

  every 30.minutes, "warm_up_job_applications_stats_cache" do
    [
      (1.month.ago.to_date..1.day.ago.to_date),
      (1.month.ago.to_date..Time.zone.today),
      (1.month.ago.beginning_of_month.to_date..1.day.ago.to_date),
      (1.month.ago.beginning_of_month.to_date..Time.zone.today),
      (1.month.ago.beginning_of_month.to_date..1.month.ago.end_of_month.to_date),
      (2.months.ago.beginning_of_month.to_date..2.months.ago.end_of_month.to_date),
      (2.months.ago.beginning_of_month.to_date..1.day.ago.to_date),
      (2.months.ago.beginning_of_month.to_date..Time.zone.today)
    ].each_with_index do |date_range, index|
      WarmUpJobApplicationsStatsCacheJob.set(wait: index.minutes).perform_later(
        start_date: date_range.first,
        end_date: date_range.last
      )
    end
  end
end
