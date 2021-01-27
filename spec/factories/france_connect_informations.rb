# frozen_string_literal: true

FactoryBot.define do
  factory :france_connect_information do
    openid { 'MyString' }
    email { 'MyString' }
    family_name { 'MyString' }
    given_name { 'MyString' }
    user
  end
end
