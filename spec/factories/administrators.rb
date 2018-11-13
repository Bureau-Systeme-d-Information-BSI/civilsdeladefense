FactoryBot.define do
  factory :administrator, aliases: [:owner] do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    role 'bant'
    very_first_account true
    password 'f4k3p455w0rD!'
    confirmed_at { DateTime.now }
  end
end
