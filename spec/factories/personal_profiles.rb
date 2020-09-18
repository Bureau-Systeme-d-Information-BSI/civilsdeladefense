# frozen_string_literal: true

FactoryBot.define do
  factory :personal_profile do
    current_position { 'CEO' }
    phone { '06' }
    website_url { 'MyString' }
    gender { 1 }
    is_currently_employed { false }
    age_range { AgeRange.all.sample }
    availability_range { AvailabilityRange.all.sample }
    study_level { StudyLevel.all.sample }
    experience_level { ExperienceLevel.all.sample }
    has_corporate_experience { false }
  end
end
