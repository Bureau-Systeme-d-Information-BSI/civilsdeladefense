# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_file do
    content do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/document.pdf"),
        "application/pdf"
      )
    end
    job_application_file_type
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
