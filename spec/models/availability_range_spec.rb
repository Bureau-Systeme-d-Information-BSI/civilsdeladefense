# frozen_string_literal: true

require "rails_helper"

RSpec.describe AvailabilityRange, type: :model do
  it { should validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: availability_ranges
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_availability_ranges_on_name      (name)
#  index_availability_ranges_on_position  (position)
#
