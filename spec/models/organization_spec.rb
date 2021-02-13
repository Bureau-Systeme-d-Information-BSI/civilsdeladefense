# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  it 'is valid with valid attributes' do
    @organization = organizations(:cvd)
    expect(@organization).to be_valid
  end

  it { should validate_presence_of(:service_name) }
  it { should validate_presence_of(:brand_name) }
  it { should validate_presence_of(:prefix_article) }
  it { should validate_presence_of(:subdomain) }
end
