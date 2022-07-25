# frozen_string_literal: true

FactoryBot.define do
  factory :organization_default do
    value { "a value" }
    kind { :job_offer_description }
    organization { Organization.last }
  end
end
