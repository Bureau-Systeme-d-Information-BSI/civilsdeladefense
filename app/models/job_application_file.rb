# frozen_string_literal: true

# Container for real file mandatory to fullfill a job application
class JobApplicationFile < ApplicationRecord
  attr_accessor :job_application_file_existing_id

  belongs_to :job_application
  belongs_to :job_application_file_type

  mount_uploader :content, DocumentUploader, mount_on: :content_file_name
  validates :content,
    file_size: {less_than: 2.megabytes}

  attr_accessor :do_not_provide_immediately

  validates :content, presence: true, unless: proc { |file| file.do_not_provide_immediately }
  validates :job_application_file_type_id, uniqueness: {scope: :job_application_id}

  before_validation do
    if job_application_file_existing_id
      existing = JobApplicationFile.find_by(id: job_application_file_existing_id)
      self.content = existing&.content
    end
  end

  def check!
    update_column :is_validated, 1
  end

  def uncheck!
    update_column :is_validated, 2
  end
end

# == Schema Information
#
# Table name: job_application_files
#
#  id                               :uuid             not null, primary key
#  content_file_name                :string
#  encrypted_file_transfer_in_error :boolean          default(FALSE)
#  is_validated                     :integer          default(0)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  job_application_file_type_id     :uuid
#  job_application_id               :uuid
#
# Indexes
#
#  index_job_application_files_on_job_application_file_type_id  (job_application_file_type_id)
#  index_job_application_files_on_job_application_id            (job_application_id)
#
# Foreign Keys
#
#  fk_rails_334ab4b230  (job_application_file_type_id => job_application_file_types.id)
#  fk_rails_d6522ee61f  (job_application_id => job_applications.id)
#
