# frozen_string_literal: true

FactoryBot.define do
  factory :employer do
    name { Faker::Company.unique.name }
    code { SecureRandom.hex(3) }
  end
end

# == Schema Information
#
# Table name: employers
#
#  id             :uuid             not null, primary key
#  children_count :integer          default(0), not null
#  code           :string
#  depth          :integer          default(0)
#  lft            :integer
#  name           :string
#  rgt            :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :uuid
#
# Indexes
#
#  index_employers_on_name  (name) UNIQUE
#
