# frozen_string_literal: true

FactoryBot.define do
  factory :level do
    name { Faker::Name.unique.name }
  end
end

# == Schema Information
#
# Table name: levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_levels_on_name      (name) UNIQUE
#  index_levels_on_position  (position)
#
