# frozen_string_literal: true

# The name/type of file attached to a job application.
# The list of names/types is managed by the administrators of the platform.
class JobApplicationFileType < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  mount_uploader :content, DocumentUploader, mount_on: :content_file_name

  validates :name, :kind, :from_state, :to_state, presence: true
  validates :required_from_state, :required_to_state, if: -> { required? }, presence: true
  validate :must_have_administrator_visibility_rule
  validate :must_have_user_visibility_rule

  enum kind: {
    applicant_provided: 10,
    employment_authority_provided: 13,
    manager_provided: 11,
    employer_provided: 12,
    check_only_admin_only: 40
  }

  enum from_state: JobApplication.states
  enum to_state: JobApplication.states, _prefix: true
  enum required_from_state: JobApplication.states, _prefix: true
  enum required_to_state: JobApplication.states, _prefix: true

  scope :for_states_around, ->(state) {
    where(kind: :applicant_provided)
      .where("from_state <= ?", JobApplication.states[state])
      .where("to_state > ?", JobApplication.states[state])
  }

  scope :for_applicant, ->(state) { where(kind: :applicant_provided, from_state: JobApplication.states[state]) }
  scope :required, ->(state) {
    where(required: true)
      .where("required_from_state <= ?", JobApplication.states[state])
      .where("required_to_state > ?", JobApplication.states[state])
  }

  has_many :job_application_files, dependent: :nullify
  has_many :visibility_rules, dependent: :destroy
  accepts_nested_attributes_for :visibility_rules, allow_destroy: true

  private

  def must_have_administrator_visibility_rule
    rules = visibility_rules.reject(&:marked_for_destruction?)
    errors.add(:visibility_rules, :must_have_administrator) unless rules.any?(&:administrator?)
  end

  def must_have_user_visibility_rule
    rules = visibility_rules.reject(&:marked_for_destruction?)
    errors.add(:visibility_rules, :must_have_user) unless rules.any?(&:user?)
  end

  public

  def is_mandatory?(state)
    from_state_as_val = JobApplication.states[from_state]
    current_state_as_val = JobApplication.states[state]

    current_state_as_val >= from_state_as_val
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
