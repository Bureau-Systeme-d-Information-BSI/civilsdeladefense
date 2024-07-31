# frozen_string_literal: true

FactoryBot.define do
  factory :availability_range do
    name { Faker::Name.unique.name }
    position { 1 }
  end
end

# == Schema Information
#
# Table name: availability_ranges
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_availability_ranges_on_name      (name) UNIQUE
#  index_availability_ranges_on_position  (position)
#
