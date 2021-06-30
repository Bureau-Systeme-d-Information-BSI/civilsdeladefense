FactoryBot.define do
  factory :frequently_asked_question do
    name { "MyString" }
    position { 1 }
    description { "MyString" }
  end
end

# == Schema Information
#
# Table name: frequently_asked_questions
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
