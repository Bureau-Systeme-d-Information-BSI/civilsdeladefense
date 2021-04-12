# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.0"
gem "rails-i18n"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
gem "puma"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.11"
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

gem "aasm"
gem "acts_as_list"
gem "audited"
gem "awesome_nested_set"
gem "cancancan"
gem "carrierwave"
gem "charlock_holmes", require: false
gem "counter_culture"
gem "country_select"
gem "devise"
gem "file_validators"
gem "fog-aws"
gem "friendly_id"
gem "groupdate"
gem "haml-rails"
gem "inherited_resources"
gem "invisible_captcha"
gem "lockbox", "~> 0.2.0"
gem "mail"
gem "mini_magick"
gem "pg_search"
gem "rack-cors"
gem "rack-rewrite"
gem "ransack"
gem "redis"
gem "rollbar"
gem "sequenced"
gem "simple_form"
gem "trix-rails", require: "trix"
gem "turbolinks", require: false
gem "turbo-rails"
gem "will_paginate"

gem "clockwork" # simulate cron on Scalingo

gem "faker", require: false

gem "omniauth_openid_connect", "~> 0.3.5"
gem "omniauth-rails_csrf_protection"

group :development do
  gem "letter_opener"
end

group :development, :test do
  gem "brakeman", require: false
  gem "byebug", platforms: %i[mri mingw x64_mingw]

  gem "dotenv-rails"

  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec_junit_formatter"
  gem "rspec-rails", "~> 4.0.1"
  gem "shoulda-matchers"
  gem "simplecov", require: false

  ## Linting
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "rubocop-performance"
  gem "standard", "> 0.10"

  gem "pry", "~> 0.13.1"
end

group :development do
  gem "annotate"

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :production do
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15", "< 4.0"
  gem "guard-rspec"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
