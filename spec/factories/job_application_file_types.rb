# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_file_type do
    name { 'CV' }
    from_state { :initial }
    kind { :applicant_provided }
    by_default { true }
  end
end
