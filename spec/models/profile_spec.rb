# frozen_string_literal: true

require "rails_helper"

RSpec.describe Profile do
  let(:profile) { build(:profile) }

  describe "associations" do
    it { is_expected.to have_one(:resume).dependent(:destroy) }
  end

  it "is valid with valid attributes" do
    expect(profile).to be_valid
  end

  it "has correct gender" do
    profile.gender = 2
    expect(profile.gender).to eq("male")
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id                       :uuid             not null, primary key
#  gender                   :integer
#  has_corporate_experience :boolean
#  is_currently_employed    :boolean
#  profileable_type         :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  age_range_id             :uuid
#  availability_range_id    :uuid
#  experience_level_id      :uuid
#  profileable_id           :uuid
#  study_level_id           :uuid
#
# Indexes
#
#  index_personal_profileable_type_and_id   (profileable_type,profileable_id)
#  index_profiles_on_age_range_id           (age_range_id)
#  index_profiles_on_availability_range_id  (availability_range_id)
#  index_profiles_on_experience_level_id    (experience_level_id)
#  index_profiles_on_study_level_id         (study_level_id)
#
# Foreign Keys
#
#  fk_rails_75f0622ea4  (availability_range_id => availability_ranges.id)
#  fk_rails_a4e341a6cb  (study_level_id => study_levels.id)
#  fk_rails_a9c80e4a8d  (experience_level_id => experience_levels.id)
#  fk_rails_b71acccf4c  (age_range_id => age_ranges.id)
#
