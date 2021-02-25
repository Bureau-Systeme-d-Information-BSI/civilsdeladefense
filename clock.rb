# frozen_string_literal: true

require "clockwork"
require "./config/boot"
require "./config/environment"

# Clockwork/cron-like rules definition
module Clockwork
  error_handler do |error|
    Rollbar.error(error)
  end

  configure do |config|
    config[:tz] = "Europe/Paris"
  end

  cond = ENV["CRON_FETCH_INBOUND"].present?
  if cond
    every 5.minutes, "inbound_message_fetch_and_process" do
      InboundMessage.fetch_and_process
    end
  end

  cond = ENV["CRON_PURGE_USERS"].present?
  cond &&= ENV["NBR_DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"].present?
  cond &&= ENV["NBR_DAYS_NOTICE_PERIOD_BEFORE_DELETION"].present?
  if cond
    every 1.day, "purge_users", at: "03:00" do
      User.destroy_when_too_old
    end
  end

  cond = ENV["CRON_DAILY_SUMMARY"].present?
  cond ||= ENV["SEND_DAILY_SUMMARY"].present?
  if cond
    every 1.day, "daily_summary", at: "08:00" do
      DailySummary.new(day: 1.day.ago).prepare_and_send
    end
  end
end
