FactoryBot.define do
  factory :employer do
    sequence :name do |n|
      "employer_name_#{n}"
    end
  end
end
