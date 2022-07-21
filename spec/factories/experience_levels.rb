# frozen_string_literal: true

FactoryBot.define do
  factory :experience_level do
    name { Faker::Name.unique.name }
    position { 1 }
  end
end

# == Schema Information
#
# Table name: experience_levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_experience_levels_on_name      (name) UNIQUE
#  index_experience_levels_on_position  (position)
#
