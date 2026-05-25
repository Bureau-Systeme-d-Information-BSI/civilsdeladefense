# frozen_string_literal: true

class VisibilityRule < ApplicationRecord
  belongs_to :job_application_file_type

  enum :by, {administrator: "administrator", user: "user"}
  enum :state, JobApplication.states

  validates :by, presence: true
  validates :state, presence: true
end

# == Schema Information
#
# Table name: visibility_rules
#
#  id                           :uuid             not null, primary key
#  by                           :string           default("administrator"), not null
#  state                        :integer          default("initial"), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  job_application_file_type_id :uuid             not null
#
# Indexes
#
#  index_visibility_rules_on_job_application_file_type_id  (job_application_file_type_id)
#
# Foreign Keys
#
#  fk_rails_2da155b95c  (job_application_file_type_id => job_application_file_types.id)
#
