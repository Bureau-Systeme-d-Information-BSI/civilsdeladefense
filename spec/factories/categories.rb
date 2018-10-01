FactoryBot.define do
  factory :category do
    name { Faker::Commerce.unique.department }
  end
end
