FactoryBot.define do
  factory :experience_level do
    sequence :name do |n|
      "experience_level_name_#{n}"
    end
  end
end
