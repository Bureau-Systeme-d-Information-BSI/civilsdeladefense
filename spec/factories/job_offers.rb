FactoryBot.define do
  factory :job_offer do
    owner
    title { Faker::Job.title }
    description "Un super poste"
    category
    official_status
    location "Rennes, FR"
    employer
    required_profile "Un profil pointu"
    recruitment_process "Des interviews"
    contract_type
    contract_start_on { 1.year.from_now }
    is_remote_possible false
    study_level
    experience_level
    sector
    is_negotiable false
    estimate_monthly_salary_net "3k€"
    estimate_monthly_salary_gross "36k€"
  end
end
