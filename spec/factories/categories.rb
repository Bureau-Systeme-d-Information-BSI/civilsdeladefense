FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
  end
end
