FactoryBot.define do
  factory :professional_category do
    sequence :name do |n|
      "professional_category_name_#{n}"
    end
  end
end
