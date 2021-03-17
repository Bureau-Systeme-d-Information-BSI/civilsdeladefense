# frozen_string_literal: true

FactoryBot.define do
  factory :contract_duration do
    name { Faker::Commerce.unique.department }
    position { 1 }
  end
end

# == Schema Information
#
# Table name: contract_durations
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contract_durations_on_name      (name) UNIQUE
#  index_contract_durations_on_position  (position)
#
