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

  validates :name, :kind, :from_state, presence: true

  #####################################
  # Enums
  enum kind: {
    applicant_provided: 10,
    template: 20,
    admin_only: 30,
    check_only_admin_only: 40
  }

  enum from_state: JobApplication.states

  #####################################
  # Relations
  has_many :job_applications
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
#  spontaneous       :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
