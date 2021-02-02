# frozen_string_literal: true

FactoryBot.define do
  factory :france_connect_information do
    sub { SecureRandom.uuid }
    email { Faker::Internet.safe_email }
    family_name { Faker::Name.last_name }
    given_name { Faker::Name.first_name }
    user factory: :confirmed_user
  end
end
