# frozen_string_literal: true

require "rails_helper"

RSpec.describe Profile, type: :model do
  before(:all) do
    @job_application = create(:job_application)
    @profile = @job_application.profile
  end

  it "is valid with valid attributes" do
    expect(@profile).to be_valid
  end

  it "has correct gender" do
    @profile.gender = 2
    expect(@profile.gender).to eq("male")
  end
end
