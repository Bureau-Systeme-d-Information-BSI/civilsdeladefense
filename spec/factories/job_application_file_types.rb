# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_file_type do
    name { "CV" }
    to_state { :phone_meeting }
    kind { :applicant_provided }

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
#  id                  :uuid             not null, primary key
#  content_file_name   :string
#  description         :string
#  from_state          :integer
#  kind                :integer
#  name                :string
#  notification        :boolean          default(TRUE)
#  position            :integer
#  required            :boolean          default(FALSE), not null
#  required_from_state :integer          default(0)
#  required_to_state   :integer          default(11)
#  to_state            :integer          default("affected")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
