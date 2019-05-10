# frozen_string_literal: true

FactoryBot.define do
  factory :user_file do
    content 'MyString'
    user nil
    job_application_file_type nil
  end
end
