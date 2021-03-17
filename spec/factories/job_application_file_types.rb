# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_file_type do
    name { "CV" }
    from_state { :initial }
    kind { :applicant_provided }
    by_default { true }
  end
end

# == Schema Information
#
# Table name: job_application_file_types
#
#  id                :uuid             not null, primary key
#  by_default        :boolean          default(FALSE)
#  content_file_name :string
#  description       :string
#  from_state        :integer
#  kind              :integer
#  name              :string
#  position          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
