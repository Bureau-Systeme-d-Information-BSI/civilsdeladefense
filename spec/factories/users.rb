# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    password { 'f4k3p455w0rD!' }
    after(:create) do |user|
      user.personal_profile = create(:personal_profile, personal_profileable: user)
    end
  end
end
