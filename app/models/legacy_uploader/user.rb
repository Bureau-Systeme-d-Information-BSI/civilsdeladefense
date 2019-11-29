# frozen_string_literal: true

# Candidate to job offer, with legacy uploader
class LegacyUploader::User < ApplicationRecord
  self.table_name = 'users'

  mount_uploader :photo, LegacyPhotoUploader, mount_on: :photo_file_name
end
