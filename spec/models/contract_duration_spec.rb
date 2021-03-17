# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContractDuration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: contract_durations
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contract_durations_on_name      (name) UNIQUE
#  index_contract_durations_on_position  (position)
#
