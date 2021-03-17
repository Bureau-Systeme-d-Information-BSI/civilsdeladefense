# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sector, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: sectors
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sectors_on_name      (name) UNIQUE
#  index_sectors_on_position  (position)
#
