# frozen_string_literal: true

# Recruiter on the platform, with legacy uploader
class LegacyUploader::Administrator < ApplicationRecord
  self.table_name = 'administrators'

  mount_uploader :photo, LegacyPhotoUploader, mount_on: :photo_file_name
end
