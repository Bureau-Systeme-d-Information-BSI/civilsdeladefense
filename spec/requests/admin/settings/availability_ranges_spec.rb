# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::AvailabilityRanges" do
  it_behaves_like "an admin setting", :availability_range, :name, "a new name"
  it_behaves_like "a movable admin setting", :availability_range
end
