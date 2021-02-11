# frozen_string_literal: true

FactoryBot.define do
  factory :contract_type do
    name { Faker::Commerce.unique.department }
    position { 1 }
  end
end
