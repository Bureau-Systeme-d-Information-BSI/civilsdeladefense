FactoryBot.define do
  factory :employer do
    name { Faker::Company.name }
    code { Faker::Code.asin }
  end
end
