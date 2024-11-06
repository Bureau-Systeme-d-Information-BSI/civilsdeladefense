# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExperienceLevel do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "associations" do
    it { is_expected.to have_many(:job_offers).dependent(:nullify) }

    it { is_expected.to have_many(:salary_ranges).dependent(:destroy) }

    it { is_expected.to have_many(:profiles).dependent(:nullify) }

    it { is_expected.to have_many(:category_experience_levels).dependent(:destroy) }
  end
end
# == Schema Information
#
# Table name: experience_levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_experience_levels_on_name      (name) UNIQUE
#  index_experience_levels_on_position  (position)
#
