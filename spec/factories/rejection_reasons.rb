# frozen_string_literal: true

FactoryBot.define do
  factory :rejection_reason do
    name { Faker::Name.unique.name }
  end
end

# == Schema Information
#
# Table name: rejection_reasons
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rejection_reasons_on_position  (position)
#
