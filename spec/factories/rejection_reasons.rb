# frozen_string_literal: true

FactoryBot.define do
  factory :rejection_reason do
    name { Faker::Name.unique.name }
  end
end
