FactoryBot.define do
  factory :department do
    name { "MyString" }
    code_region { "MyString" }
    code { "MyString" }

    trait :none do
      code { "00" }
      name { "None" }
      code_region { nil }
      name_region { nil }
    end
  end
end

# == Schema Information
#
# Table name: departments
#
#  id          :uuid             not null, primary key
#  code        :string
#  code_region :string
#  name        :string
#  name_region :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
