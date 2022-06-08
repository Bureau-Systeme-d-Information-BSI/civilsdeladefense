# frozen_string_literal: true

FactoryBot.define do
  factory :zip_file do
    zip do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/archive.zip"),
        "application/zip"
      )
    end
  end
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
