# frozen_string_literal: true

FactoryBot.define do
  factory :job_offer do
    owner
    organization { Organization.first }
    title { "#{Faker::Job.title} F/H" }
    description { "Un super poste" }
    organization_description { "Une super organisation" }
    category
    professional_category { ProfessionalCategory.all.sample }
    location { "Rennes, FR" }
    employer
    required_profile { "Un profil pointu" }
    recruitment_process { "Des interviews" }
    contract_type { ContractType.find_by(name: "CDI") }
    contract_start_on { 1.year.from_now }
    is_remote_possible { false }
    study_level { StudyLevel.all.sample }
    experience_level { ExperienceLevel.all.sample }
    sector { Sector.all.sample }
    estimate_monthly_salary_net { "3k€" }
    estimate_annual_salary_gross { "36k€" }
    csp_value { "CSP#{rand(1000..9999)}" }
    csp_date { 35.days.ago }
    mobilia_value { "inconnue" }
    mobilia_date { 1.day.ago }

    factory :published_job_offer do
      published_at { 40.days.before }
      state { :published }
    end

    factory :archived_job_offer do
      archived_at { 40.days.before }
      state { :archived }
      archiving_reason
    end
  end

  trait :with_job_applications do
    after(:create) do |job_offer|
      3.times { job_offer.job_applications << create(:job_application) }
    end
  end

  trait :with_contract_duration do
    contract_type { association :contract_type, duration: true }
    contract_duration { association :contract_duration }
  end
end

# == Schema Information
#
# Table name: job_offers
#
#  id                                               :uuid             not null, primary key
#  accepted_job_applications_count                  :integer          default(0), not null
#  affected_job_applications_count                  :integer          default(0), not null
#  after_meeting_rejected_job_applications_count    :integer          default(0), not null
#  archived_at                                      :datetime
#  city                                             :string
#  contract_drafting_job_applications_count         :integer          default(0), not null
#  contract_feedback_waiting_job_applications_count :integer          default(0), not null
#  contract_received_job_applications_count         :integer          default(0), not null
#  contract_start_on                                :date             not null
#  country_code                                     :string
#  county                                           :string
#  county_code                                      :integer
#  csp_date                                         :date
#  csp_value                                        :string
#  description                                      :text
#  draft_at                                         :datetime
#  estimate_annual_salary_gross                     :string
#  estimate_monthly_salary_net                      :string
#  featured                                         :boolean          default(FALSE)
#  identifier                                       :string
#  initial_job_applications_count                   :integer          default(0), not null
#  is_remote_possible                               :boolean
#  job_applications_count                           :integer          default(0), not null
#  location                                         :string
#  mobilia_date                                     :date
#  mobilia_value                                    :string
#  most_advanced_job_applications_state             :integer          default("start")
#  notifications_count                              :integer          default(0)
#  option_photo                                     :integer
#  organization_description                         :text
#  phone_meeting_job_applications_count             :integer          default(0), not null
#  phone_meeting_rejected_job_applications_count    :integer          default(0), not null
#  postcode                                         :string
#  published_at                                     :datetime
#  recruitment_process                              :text
#  region                                           :string
#  rejected_job_applications_count                  :integer          default(0), not null
#  required_profile                                 :text
#  slug                                             :string           not null
#  spontaneous                                      :boolean          default(FALSE)
#  state                                            :integer
#  suspended_at                                     :datetime
#  title                                            :string
#  to_be_met_job_applications_count                 :integer          default(0), not null
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#  archiving_reason_id                              :uuid
#  bop_id                                           :uuid
#  category_id                                      :uuid
#  contract_duration_id                             :uuid
#  contract_type_id                                 :uuid
#  employer_id                                      :uuid
#  experience_level_id                              :uuid
#  organization_id                                  :uuid
#  owner_id                                         :uuid
#  professional_category_id                         :uuid
#  sector_id                                        :uuid
#  sequential_id                                    :integer
#  study_level_id                                   :uuid
#
# Indexes
#
#  index_job_offers_on_archiving_reason_id       (archiving_reason_id)
#  index_job_offers_on_bop_id                    (bop_id)
#  index_job_offers_on_category_id               (category_id)
#  index_job_offers_on_contract_duration_id      (contract_duration_id)
#  index_job_offers_on_contract_type_id          (contract_type_id)
#  index_job_offers_on_employer_id               (employer_id)
#  index_job_offers_on_experience_level_id       (experience_level_id)
#  index_job_offers_on_identifier                (identifier) UNIQUE
#  index_job_offers_on_organization_id           (organization_id)
#  index_job_offers_on_owner_id                  (owner_id)
#  index_job_offers_on_professional_category_id  (professional_category_id)
#  index_job_offers_on_sector_id                 (sector_id)
#  index_job_offers_on_slug                      (slug) UNIQUE
#  index_job_offers_on_state                     (state)
#  index_job_offers_on_study_level_id            (study_level_id)
#
# Foreign Keys
#
#  fk_rails_1d6fc1ac2d  (professional_category_id => professional_categories.id)
#  fk_rails_1db997256c  (experience_level_id => experience_levels.id)
#  fk_rails_2e21ee1517  (study_level_id => study_levels.id)
#  fk_rails_39bc76a4ec  (contract_type_id => contract_types.id)
#  fk_rails_3afb853ff8  (bop_id => bops.id)
#  fk_rails_4cbd429856  (archiving_reason_id => archiving_reasons.id)
#  fk_rails_578c30296c  (category_id => categories.id)
#  fk_rails_5aaea6c8db  (employer_id => employers.id)
#  fk_rails_6cf1ead2e5  (owner_id => administrators.id)
#  fk_rails_ee7a101e4f  (sector_id => sectors.id)
#
