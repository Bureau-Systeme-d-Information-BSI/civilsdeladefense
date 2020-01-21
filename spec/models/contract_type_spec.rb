# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractType, type: :model do
  it { should validate_presence_of(:name) }
end
