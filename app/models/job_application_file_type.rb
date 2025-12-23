# frozen_string_literal: true

# The name/type of file attached to a job application.
# The list of names/types is managed by the administrators of the platform.
class JobApplicationFileType < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  #####################################
  # File uploads
  mount_uploader :content, DocumentUploader, mount_on: :content_file_name

  #####################################
  # Validations

  validates :name, :kind, :from_state, :to_state, presence: true

  #####################################
  # Enums
  enum kind: {
    applicant_provided: 10,
    manager_provided: 11,
    employer_provided: 12,
    check_only_admin_only: 40
  }

  enum from_state: JobApplication.states
  enum to_state: JobApplication.states, _prefix: true

  scope :for_states_around, ->(state) {
    where(by_default: true, kind: :applicant_provided)
      .where("from_state <= ?", JobApplication.states[state])
      .where("to_state > ?", JobApplication.states[state])
  }

  scope :by_default, ->(state) {
    where(by_default: true, kind: :applicant_provided)
      .where(from_state: JobApplication.states[state])
  }

  #####################################
  # Relations
  has_many :job_application_files, dependent: :nullify

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
#  id                :uuid             not null, primary key
#  by_default        :boolean          default(FALSE)
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
