# frozen_string_literal: true

FactoryBot.define do
  factory :bop do
    name { Faker::Name.unique.name }
  end
end
