FactoryBot.define do
  factory :foreign_language do
    name { "MyString" }
    position { 1 }
  end
end

# == Schema Information
#
# Table name: foreign_languages
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
