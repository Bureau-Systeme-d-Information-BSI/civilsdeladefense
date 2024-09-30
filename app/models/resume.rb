class Resume < ApplicationRecord
  belongs_to :profile

  mount_uploader :content, DocumentUploader, mount_on: :content_file_name
  validates :content, file_size: {less_than: 2.megabytes}

  validates :content, presence: true
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
