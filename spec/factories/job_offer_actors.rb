# frozen_string_literal: true

FactoryBot.define do
  factory :job_offer_actor do
    job_offer
    administrator
    role { JobOfferActor.roles.keys.first }
  end
end
