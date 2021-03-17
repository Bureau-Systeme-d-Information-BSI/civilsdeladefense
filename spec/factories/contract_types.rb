# frozen_string_literal: true

FactoryBot.define do
  factory :contract_type do
    name { Faker::Commerce.unique.department }
    position { 1 }
  end
end

# == Schema Information
#
# Table name: contract_types
#
#  id         :uuid             not null, primary key
#  duration   :boolean          default(FALSE)
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contract_types_on_name      (name) UNIQUE
#  index_contract_types_on_position  (position)
#
