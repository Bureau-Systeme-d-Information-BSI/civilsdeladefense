# frozen_string_literal: true

FactoryBot.define do
  factory :email, class: "Email" do
    subject { "New email" }
    body { "MyText" }
    job_application
    association :sender, factory: :administrator
  end
end
