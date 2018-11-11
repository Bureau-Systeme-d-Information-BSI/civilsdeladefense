require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  error_handler do |error|
    Rollbar.error(error)
  end

  configure do |config|
    config[:tz] = 'Europe/Paris'
  end

  every 5.minutes, "inbound_message_fetch_and_process" do
    InboundMessage.fetch_and_process
  end
end
