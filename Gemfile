# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
gem 'rails-i18n'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'aasm'
gem 'acts_as_list'
gem 'audited'
gem 'awesome_nested_set'
gem 'cancancan'
gem 'carrierwave'
gem 'counter_culture'
gem 'country_select'
gem 'devise'
gem 'file_validators'
gem 'fog-aws'
gem 'friendly_id'
gem 'groupdate'
gem 'haml-rails'
gem 'inherited_resources'
gem 'invisible_captcha'
gem 'lockbox', '~> 0.2.0'
gem 'mail'
gem 'mini_magick'
gem 'pg_search'
gem 'rack-rewrite'
gem 'ransack'
gem 'redis'
gem 'rollbar'
gem 'sequenced'
gem 'simple_form'
gem 'sqreen'
gem 'turbolinks'
gem 'will_paginate'

gem 'clockwork' # simulate cron on Scalingo

gem 'faker', require: false

group :development do
  gem 'letter_opener'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.0.beta3'
  gem 'rspec_junit_formatter'
  gem 'rubocop', require: false
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'guard-rspec'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
