# frozen_string_literal: true

FactoryBot.define do
  factory :study_level do
    name { Faker::Name.unique.name }
  end
end

# == Schema Information
#
# Table name: study_levels
#
#  id             :uuid             not null, primary key
#  name           :string
#  official_level :integer
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_study_levels_on_name      (name) UNIQUE
#  index_study_levels_on_position  (position)
#
