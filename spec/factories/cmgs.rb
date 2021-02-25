# frozen_string_literal: true

FactoryBot.define do
  factory :cmg do
    email { "cmg@molo.org" }
    organization { Organization.first }
  end
end
