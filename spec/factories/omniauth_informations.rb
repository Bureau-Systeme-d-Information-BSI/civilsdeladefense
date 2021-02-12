# frozen_string_literal: true

FactoryBot.define do
  factory :omniauth_information do
    provider { :france_connect }
    uid { SecureRandom.uuid }
    email { Faker::Internet.safe_email }
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    user factory: :confirmed_user
  end
end
