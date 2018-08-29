FactoryBot.define do
  factory :administrator, aliases: [:owner] do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password 'f4k3p455w0rd'
  end
end
