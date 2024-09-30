FactoryBot.define do
  factory :resume do
    profile
    content do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/document.pdf"),
        "application/pdf"
      )
    end
  end
end

# == Schema Information
#
# Table name: resumes
#
#  id                :uuid             not null, primary key
#  content_file_name :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  profile_id        :uuid             not null
#
# Indexes
#
#  index_resumes_on_profile_id  (profile_id)
#
# Foreign Keys
#
#  fk_rails_73bf243e21  (profile_id => profiles.id)
#
