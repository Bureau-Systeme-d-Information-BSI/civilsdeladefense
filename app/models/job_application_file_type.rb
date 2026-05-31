# frozen_string_literal: true

# The name/type of file attached to a job application.
# The list of names/types is managed by the administrators of the platform.
class JobApplicationFileType < ApplicationRecord
  # TODO: @sebastiencarceles remove these columns from DB after v2
  self.ignored_columns += %i[from_state required_from_state to_state required_to_state]

  COVER_LETTER_NAME = "Lettre de Motivation"

  acts_as_list
  default_scope -> { order(position: :asc) }

  mount_uploader :content, DocumentUploader, mount_on: :content_file_name

  validates :name, :kind, presence: true

  enum :kind, {
    applicant_provided: 10,
    employment_authority_provided: 13,
    manager_provided: 11,
    employer_provided: 12,
    check_only_admin_only: 40
  }

  scope :visible_by_user, ->(state) {
    where(kind: :applicant_provided)
      .joins(:visibility_rules)
      .where(visibility_rules: {by: :user, state:})
  }

  scope :visible_by_user_up_to, ->(state) {
    where(kind: :applicant_provided)
      .joins(:visibility_rules)
      .where(visibility_rules: {by: :user})
      .where("visibility_rules.state <= ?", JobApplication.states[state])
      .distinct
  }

  scope :excluding_cover_letter, -> { where.not(name: COVER_LETTER_NAME) }

  scope :notifiable_by_user_at, ->(state) {
    where(notify_user: true)
      .joins(:visibility_rules)
      .where(visibility_rules: {by: :user, state:})
      .reorder(nil)
      .distinct
  }

  scope :visible_by, ->(administrator, state) {
    scope = joins(:visibility_rules)
      .where(visibility_rules: {by: :administrator})
      .where("visibility_rules.state <= ?", JobApplication.states[state])
      .distinct
    scope = scope.manager_provided if administrator.hr_manager? || administrator.payroll_manager?
    scope
  }

  scope :required, ->(state) {
    where(required: true)
      .joins(:visibility_rules)
      .where(visibility_rules: {by: :administrator})
      .where("visibility_rules.state <= ?", JobApplication.states[state])
      .reorder(nil)
      .distinct
  }

  scope :mandatory, ->(state) {
    state_value = JobApplication.states[state]

    where(
      required: true,
      id: VisibilityRule.where(by: :administrator)
        .where("state <= ?", state_value)
        .select(:job_application_file_type_id)
    ).or(
      where(
        required: false,
        id: VisibilityRule.where(by: :administrator)
          .group(:job_application_file_type_id)
          .having("MAX(state) < ?", state_value)
          .select(:job_application_file_type_id)
      )
    )
  }

  VALIDATOR_ROLE_MAPPING = {
    validate_by_employer_recruiter: :employer_recruiter?,
    validate_by_employment_authority: :employment_authority?,
    validate_by_hr_manager: :hr_manager?,
    validate_by_payroll_manager: :payroll_manager?
  }.freeze

  scope :automatically_validated, -> { where(VALIDATOR_ROLE_MAPPING.keys.index_with(false)) }

  has_many :job_application_files, dependent: :restrict_with_error
  has_many :visibility_rules, dependent: :destroy
  accepts_nested_attributes_for :visibility_rules, allow_destroy: true

  def can_validate?(administrator)
    return true if administrator.functional_administrator?

    VALIDATOR_ROLE_MAPPING.any? { |flag, role_method| self[flag] && administrator.public_send(role_method) }
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
