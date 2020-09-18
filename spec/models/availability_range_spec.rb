# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvailabilityRange, type: :model do
  it { should validate_presence_of(:name) }
end
