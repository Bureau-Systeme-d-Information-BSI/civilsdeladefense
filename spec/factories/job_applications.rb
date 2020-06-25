# frozen_string_literal: true

FactoryBot.define do
  factory :job_application do
    job_offer
    organization { Organization.first }
    user

    before(:create) do |job_application|
      job_application.personal_profile = create(:personal_profile,
                                                personal_profileable: job_application)
    end
  end
end
