# frozen_string_literal: true

FactoryBot.define do
  factory :bop do
    name { Faker::Name.unique.name }
  end
end

# == Schema Information
#
# Table name: bops
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bops_on_name      (name) UNIQUE
#  index_bops_on_position  (position)
#
