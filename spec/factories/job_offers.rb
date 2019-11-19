# frozen_string_literal: true

FactoryBot.define do
  factory :job_offer do
    owner
    organization { Organization.first }
    title { Faker::Job.title }
    description { 'Un super poste' }
    category
    professional_category { ProfessionalCategory.all.sample }
    location { 'Rennes, FR' }
    employer
    required_profile { 'Un profil pointu' }
    recruitment_process { 'Des interviews' }
    contract_type { ContractType.find_by_name('CDD') }
    duration_contract { '12 mois' }
    contract_start_on { 1.year.from_now }
    is_remote_possible { false }
    study_level { StudyLevel.all.sample }
    experience_level { ExperienceLevel.all.sample }
    sector { Sector.all.sample }
    estimate_monthly_salary_net { '3k€' }
    estimate_annual_salary_gross { '36k€' }
  end
end
