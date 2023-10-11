# frozen_string_literal: true

require "rails_helper"

RSpec.describe Benefit do
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: benefits
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_benefits_on_name      (name) UNIQUE
#  index_benefits_on_position  (position)
#
