# frozen_string_literal: true

FactoryBot.define do
  factory :professional_category do
    name { Faker::Name.unique.name }
  end
end

# == Schema Information
#
# Table name: professional_categories
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_professional_categories_on_name      (name) UNIQUE
#  index_professional_categories_on_position  (position)
#
