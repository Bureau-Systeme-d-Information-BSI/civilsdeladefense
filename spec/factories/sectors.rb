FactoryBot.define do
  factory :sector do
    sequence :name do |n|
      "sector_name_#{n}"
    end
  end
end
