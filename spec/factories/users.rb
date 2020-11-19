# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    organization { Organization.first }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    current_position { 'CEO' }
    phone { '06' }
    website_url { 'MyString' }
    email { Faker::Internet.safe_email }
    password { 'f4k3p455w0rD!' }
    terms_of_service { true }
    certify_majority { true }
  end

  factory :confirmed_user, parent: :user do
    after(:create) { |user| user.confirm }
  end
end
