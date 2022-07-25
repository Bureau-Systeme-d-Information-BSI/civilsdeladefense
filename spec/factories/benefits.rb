# frozen_string_literal: true

FactoryBot.define do
  factory :benefit do
    name { Faker::Name.unique.name }
  end
end

# == Schema Information
#
# Table name: benefits
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_benefits_on_name      (name) UNIQUE
#  index_benefits_on_position  (position)
#
