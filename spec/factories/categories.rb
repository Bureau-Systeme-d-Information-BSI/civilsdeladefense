FactoryBot.define do
  factory :category do
    sequence :name do |n|
      "category_name_#{n}"
    end
  end
end
