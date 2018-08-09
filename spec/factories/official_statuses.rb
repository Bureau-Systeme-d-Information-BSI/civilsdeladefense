FactoryBot.define do
  factory :official_status do
    sequence :name do |n|
      "official_status_name_#{n}"
    end
  end
end
