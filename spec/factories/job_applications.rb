# frozen_string_literal: true

FactoryBot.define do
  factory :job_application do
    job_offer
    organization { Organization.first }
    user
  end

  trait :with_job_application_file do
    after(:create) do |job_application|
      job_application.job_application_files << build(:job_application_file)
    end
  end
end

# == Schema Information
#
# Table name: job_applications
#
#  id                                :uuid             not null, primary key
#  administrator_notifications_count :integer          default(0)
#  emails_administrator_unread_count :integer          default(0)
#  emails_count                      :integer          default(0)
#  emails_unread_count               :integer          default(0)
#  emails_user_unread_count          :integer          default(0)
#  experiences_fit_job_offer         :boolean
#  files_count                       :integer          default(0)
#  files_unread_count                :integer          default(0)
#  preselection                      :integer          default("pending")
#  skills_fit_job_offer              :boolean
#  state                             :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  category_id                       :uuid
#  employer_id                       :uuid
#  job_offer_id                      :uuid
#  organization_id                   :uuid
#  rejection_reason_id               :uuid
#  user_id                           :uuid
#
# Indexes
#
#  index_job_applications_on_category_id          (category_id)
#  index_job_applications_on_employer_id          (employer_id)
#  index_job_applications_on_job_offer_id         (job_offer_id)
#  index_job_applications_on_organization_id      (organization_id)
#  index_job_applications_on_rejection_reason_id  (rejection_reason_id)
#  index_job_applications_on_state                (state)
#  index_job_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_0e9ee51b69  (user_id => users.id)
#  fk_rails_36c9b0d626  (category_id => categories.id)
#  fk_rails_88b000fe87  (job_offer_id => job_offers.id)
#  fk_rails_e668fb8ac4  (employer_id => employers.id)
#  fk_rails_e73e1d195a  (rejection_reason_id => rejection_reasons.id)
#
