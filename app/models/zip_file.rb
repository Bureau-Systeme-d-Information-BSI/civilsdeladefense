# frozen_string_literal: true

class ZipFile < ApplicationRecord
  mount_uploader :zip, ZipUploader

  after_create -> { DestroyZipFileJob.set(wait: 1.day).perform_later(id: id) }
end

# == Schema Information
#
# Table name: zip_files
#
#  id         :uuid             not null, primary key
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
