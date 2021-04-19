FactoryBot.define do
  factory :foreign_language_level do
    name { "MyString" }
    position { 1 }
  end
end

# == Schema Information
#
# Table name: foreign_language_levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
