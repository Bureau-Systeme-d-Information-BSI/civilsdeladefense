# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Levels" do
  it_behaves_like "an admin setting", :level, :name, "a new name"
  it_behaves_like "a movable admin setting", :level
end
