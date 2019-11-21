# frozen_string_literal: true

FactoryBot.define do
  factory :administrator, aliases: [:owner] do
    organization { Organization.first }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    role { 'bant' }
    very_first_account { true }
    password { 'f4k3p455w0rD!' }
    confirmed_at { DateTime.now }
  end
end
