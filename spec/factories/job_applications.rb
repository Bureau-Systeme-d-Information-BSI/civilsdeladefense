FactoryBot.define do
  factory :job_application do
    job_offer
    user
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    current_position "MyString"
    phone "MyString"
    address_1 "MyString"
    address_2 "MyString"
    postal_code "MyString"
    city "MyString"
    country "MyString"
    website_url "MyString"
  end
end
