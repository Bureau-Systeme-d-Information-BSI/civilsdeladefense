# frozen_string_literal: true

# The name/type of file attached to a job application.
# The list of names/types is managed by the administrators of the platform,
# with legacy uploader
class LegacyUploader::JobApplicationFileType < ApplicationRecord
  self.table_name = 'job_application_file_types'

  mount_uploader :content, LegacyDocumentUploader, mount_on: :content_file_name
end
