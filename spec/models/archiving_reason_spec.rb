# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArchivingReason, type: :model do
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: archiving_reasons
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_archiving_reasons_on_position  (position)
#
