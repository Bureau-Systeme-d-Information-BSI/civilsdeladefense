# frozen_string_literal: true

require "rails_helper"

RSpec.describe Profile do
  describe "validations" do
    it { expect(build(:profile)).to be_valid }

    it { expect(build(:profile, :with_resume)).to be_valid }

    it "has correct gender" do
      profile = build(:profile)
      profile.gender = 2
      expect(profile.gender).to eq("male")
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:profileable) }

    it { is_expected.to belong_to(:study_level).optional }

    it { is_expected.to belong_to(:experience_level).optional }

    it { is_expected.to belong_to(:availability_range).optional }

    it { is_expected.to belong_to(:age_range).optional }

    it { is_expected.to have_many(:profile_foreign_languages).dependent(:destroy) }

    it { is_expected.to have_many(:category_experience_levels).dependent(:destroy) }

    it { is_expected.to have_many(:department_profiles).dependent(:destroy) }

    it { is_expected.to have_many(:departments).through(:department_profiles) }
  end

  describe "after_save callbacks" do
    describe "#add_none_department" do
      subject(:profile_save) { profile.save! }

      let(:profile) { build(:profile) }

      before do
        create(:department, :none)
        profile_save
      end

      context "when user has no department" do
        it { expect(profile.reload.departments).to eq([Department.none]) }
      end

      context "when user has a department" do
        before { profile.departments << create(:department) }

        it { expect(profile.reload.departments).not_to eq([Department.none]) }
      end
    end

    describe "#dedupe_departments" do
      subject(:profile_save) { profile.save! }

      let(:profile) { create(:profile) }

      before do
        profile.departments << Department.none
        profile_save
      end

      it { expect(profile.reload.departments).to eq([Department.none]) }
    end
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
#  resume_file_name         :string
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
