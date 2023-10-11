# frozen_string_literal: true

require "rails_helper"

RSpec.describe AgeRange do
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: age_ranges
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_age_ranges_on_name      (name)
#  index_age_ranges_on_position  (position)
#
