FactoryBot.define do
  factory :admin, aliases: [:owner] do
    sequence :email do |n|
      "admin#{n}@example.com"
    end
    password 'f4k3p455w0rd'
  end
end
