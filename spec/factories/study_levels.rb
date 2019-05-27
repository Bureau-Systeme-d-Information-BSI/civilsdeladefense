# frozen_string_literal: true

FactoryBot.define do
  factory :study_level do
    sequence :name do |n|
      "study_level_name_#{n}"
    end
  end
end
