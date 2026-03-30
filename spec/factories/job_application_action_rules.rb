# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_action_rule do
    role { :employer_recruiter }
    state { :initial }
    to_state { nil }
    read { true }
    manage_user_info { false }
    manage_state { false }
    manage_file { false }
    reject { false }
    comment { false }
    send_email { false }
    validate_dar { false }
  end
end

# == Schema Information
#
# Table name: job_application_action_rules
#
#  id               :uuid             not null, primary key
#  comment          :boolean          default(FALSE), not null
#  manage_file      :boolean          default(FALSE), not null
#  manage_state     :boolean          default(FALSE), not null
#  manage_user_info :boolean          default(FALSE), not null
#  read             :boolean          default(FALSE), not null
#  reject           :boolean          default(FALSE), not null
#  role             :integer          not null
#  send_email       :boolean          default(FALSE), not null
#  state            :integer          not null
#  to_state         :integer
#  validate_dar     :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_job_application_action_rules_on_role_and_state  (role,state) UNIQUE
#
