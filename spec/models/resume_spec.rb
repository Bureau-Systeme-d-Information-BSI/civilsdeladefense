require "rails_helper"

RSpec.describe Resume do
  describe "factory" do
    it { expect(build(:resume)).to be_valid }
  end

  describe "associations" do
    it { is_expected.to belong_to(:profile) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
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
