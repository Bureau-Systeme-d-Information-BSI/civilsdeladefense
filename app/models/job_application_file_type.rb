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
    check_only_admin_only: 40,
  }

  enum from_state: JobApplication.states
end
