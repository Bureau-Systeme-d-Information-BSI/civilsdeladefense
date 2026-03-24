# frozen_string_literal: true

# The name/type of file attached to a job application.
# The list of names/types is managed by the administrators of the platform.
class JobApplicationFileType < ApplicationRecord
  # TODO: @sebastiencarceles remove these columns from DB after v2
  self.ignored_columns += %i[from_state required_from_state to_state]

  acts_as_list
  default_scope -> { order(position: :asc) }

  mount_uploader :content, DocumentUploader, mount_on: :content_file_name

  validates :name, :kind, presence: true
  validates :required_to_state, if: -> { required? }, presence: true
  validate :must_have_administrator_visibility_rule
  validate :must_have_user_visibility_rule

  enum kind: {
    applicant_provided: 10,
    employment_authority_provided: 13,
    manager_provided: 11,
    employer_provided: 12,
    check_only_admin_only: 40
  }

  enum required_to_state: JobApplication.states, _prefix: true

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

  scope :required, ->(state) {
    where(
      id: VisibilityRule.where(by: :administrator)
        .group(:job_application_file_type_id)
        .having("MAX(state) <= ?", JobApplication.states[state])
        .select(:job_application_file_type_id)
    )
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
