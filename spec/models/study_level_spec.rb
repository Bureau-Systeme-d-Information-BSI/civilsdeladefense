# frozen_string_literal: true

require "rails_helper"

RSpec.describe StudyLevel, type: :model do
  it { should validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: study_levels
#
#  id             :uuid             not null, primary key
#  name           :string
#  official_level :integer
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_study_levels_on_name      (name) UNIQUE
#  index_study_levels_on_position  (position)
#
