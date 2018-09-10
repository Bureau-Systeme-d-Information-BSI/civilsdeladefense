FactoryBot.define do
  factory :administrator, aliases: [:owner] do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    role 'bant'
    password 'f4k3p455w0rd'
    confirmed_at { DateTime.now }
  end
end
