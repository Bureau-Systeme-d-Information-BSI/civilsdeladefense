# frozen_string_literal: true

FactoryBot.define do
  factory :archiving_reason do
    name { "MyString" }
    position { 1 }
  end
end

# == Schema Information
#
# Table name: archiving_reasons
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_archiving_reasons_on_position  (position)
#
