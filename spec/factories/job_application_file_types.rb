# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_file_type do
    name { "CV" }
    kind { :applicant_provided }
    validate_by_employer_recruiter { true }

    after(:build) do |jaft|
      jaft.visibility_rules.build(by: :administrator, state: :initial)
      jaft.visibility_rules.build(by: :user, state: :initial)
    end
  end
end

# == Schema Information
#
# Table name: job_application_file_types
#
#  id                               :uuid             not null, primary key
#  content_file_name                :string
#  description                      :string
#  kind                             :integer
#  name                             :string
#  notification                     :boolean          default(TRUE)
#  notify_employer_recruiter        :boolean          default(FALSE), not null
#  notify_employment_authority      :boolean          default(FALSE), not null
#  notify_hr_manager                :boolean          default(FALSE), not null
#  notify_payroll_manager           :boolean          default(FALSE), not null
#  notify_user                      :boolean          default(FALSE), not null
#  position                         :integer
#  required                         :boolean          default(FALSE), not null
#  validate_by_employer_recruiter   :boolean          default(FALSE), not null
#  validate_by_employment_authority :boolean          default(FALSE), not null
#  validate_by_hr_manager           :boolean          default(FALSE), not null
#  validate_by_payroll_manager      :boolean          default(FALSE), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
