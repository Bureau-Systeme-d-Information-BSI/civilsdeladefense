# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExperienceLevel, type: :model do
  it { is_expected.to validate_presence_of(:name) }
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
