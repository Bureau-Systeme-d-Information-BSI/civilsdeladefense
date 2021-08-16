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

  if ENV["CRON_FETCH_INBOUND"].present?
    every 5.minutes, "inbound_message_fetch_and_process" do
      ActiveRecord::Base.connection_pool.with_connection do
        InboundMessage.fetch_and_process
      end
    end
  end

  cond = ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"].present?
  cond &&= ENV["DAYS_NOTICE_PERIOD_BEFORE_DELETION"].present?
  if cond
    every 1.day, "purge_users", at: "11:00" do
      User.destroy_when_too_old
    end
  end

  cond = ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DEACTIVATION"].present?
  cond &&= ENV["DAYS_NOTICE_PERIOD_BEFORE_DEACTIVATION"].present?
  if cond
    every 1.day, "purge_administrators", at: "11:00" do
      Administrator.deactivate_when_too_old
    end
  end

  if (ENV["SEND_DAILY_SUMMARY"] || ENV["CRON_DAILY_SUMMARY"]).present?
    every 1.day, "daily_summary", at: "08:00" do
      DailySummary.new(day: 1.day.ago).prepare_and_send
    end
  end
end
