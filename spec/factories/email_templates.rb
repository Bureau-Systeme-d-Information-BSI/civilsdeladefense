# frozen_string_literal: true

FactoryBot.define do
  factory :email_template do
    title { "MyString" }
    subject { "MyString" }
    body { "MyText" }
  end
end
