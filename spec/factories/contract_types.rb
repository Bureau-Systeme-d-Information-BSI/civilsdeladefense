# frozen_string_literal: true

FactoryBot.define do
  factory :contract_type do
    sequence :name do |n|
      "contract_type_name_#{n}"
    end
  end
end
