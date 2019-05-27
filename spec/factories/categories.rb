# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::Commerce.unique.department }
  end
end
