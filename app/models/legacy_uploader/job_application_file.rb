# frozen_string_literal: true

# Container for real file mandatory to fullfill a job application, with legacy uploader
class LegacyUploader::JobApplicationFile < ApplicationRecord
  self.table_name = 'job_application_files'

  mount_uploader :content, LegacyDocumentUploader, mount_on: :content_file_name
end
