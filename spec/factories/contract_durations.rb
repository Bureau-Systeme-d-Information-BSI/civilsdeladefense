# frozen_string_literal: true

FactoryBot.define do
  factory :contract_duration do
    name { Faker::Commerce.unique.department }
    position { 1 }
  end
end
