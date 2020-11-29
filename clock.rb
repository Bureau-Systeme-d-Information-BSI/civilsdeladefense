# frozen_string_literal: true

require 'clockwork'
require './config/boot'
require './config/environment'

# Clockwork/cron-like rules definition
module Clockwork
  error_handler do |error|
    Rollbar.error(error)
  end

  configure do |config|
    config[:tz] = 'Europe/Paris'
  end

  every 5.minutes, 'inbound_message_fetch_and_process' do
    InboundMessage.fetch_and_process
  end

  every 1.day, 'inbound_message_fetch_and_process', at: '03:00' do
    User.destroy_when_too_old
  end

  if ENV['SEND_DAILY_SUMMARY'].present?
    every 1.day, 'inbound_message_fetch_and_process', at: '08:00' do
      DailySummary.new(day: 1.day.ago).prepare_and_send
    end
  end
end
