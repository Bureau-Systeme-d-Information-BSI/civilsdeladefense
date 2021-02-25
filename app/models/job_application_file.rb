# frozen_string_literal: true

# Container for real file mandatory to fullfill a job application
class JobApplicationFile < ApplicationRecord
  belongs_to :job_application
  belongs_to :job_application_file_type

  mount_uploader :content, DocumentUploader, mount_on: :content_file_name
  validates :content,
    file_size: {less_than: 2.megabytes}

  attr_accessor :do_not_provide_immediately

  validates :content,
    presence: true,
    unless: proc { |file| file.do_not_provide_immediately }
  validates :job_application_file_type_id,
    uniqueness: {scope: :job_application_id}

  def check!
    update_column :is_validated, 1
  end

  def uncheck!
    update_column :is_validated, 2
  end
end
