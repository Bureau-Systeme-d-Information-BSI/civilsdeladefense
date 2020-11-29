# frozen_string_literal: true

FactoryBot.define do
  factory :job_application_file do
    content {
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/files/document.pdf'),
        'application/pdf'
      )
    }
    job_application_file_type

    # after :create do |b|
    #   b.update_column(:content_file_name, 'document.pdf')
    # end
  end
end
