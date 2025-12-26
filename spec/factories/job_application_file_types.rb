# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_file_type do
    name { "CV" }
    from_state { :initial }
    to_state { :phone_meeting }
    kind { :applicant_provided }
  end
end

# == Schema Information
#
# Table name: job_application_file_types
#
#  id                :uuid             not null, primary key
#  content_file_name :string
#  description       :string
#  from_state        :integer
#  kind              :integer
#  name              :string
#  notification      :boolean          default(TRUE)
#  position          :integer
#  to_state          :integer          default("affected")
#  required          :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
