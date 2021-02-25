# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { "MyString" }
    body { "MyText" }
    og_title { "MyString" }
    og_description { "MyString" }
    organization { nil }
  end
end
