# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContractType do
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: contract_types
#
#  id         :uuid             not null, primary key
#  duration   :boolean          default(FALSE)
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contract_types_on_name      (name) UNIQUE
#  index_contract_types_on_position  (position)
#
