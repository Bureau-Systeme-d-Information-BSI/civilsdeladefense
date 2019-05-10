# frozen_string_literal: true

FactoryBot.define do
  factory :employer do
    name { Faker::Company.name }
    code { Faker::Code.unique.asin }
  end
end
