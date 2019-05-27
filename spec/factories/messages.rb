# frozen_string_literal: true

FactoryBot.define do
  factory :message, class: 'Message' do
    body 'MyText'
    job_application
    administrator
  end
end
