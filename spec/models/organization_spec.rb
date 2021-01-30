# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  it 'is valid with valid attributes' do
    @organization = organizations(:cvd)
    expect(@organization).to be_valid
  end

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:business_owner_name) }
  it { should validate_presence_of(:subdomain) }
end
