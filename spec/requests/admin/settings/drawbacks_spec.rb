# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Drawbacks" do
  it_behaves_like "an admin setting", :drawback, :name, "a new name"
  it_behaves_like "a movable admin setting", :drawback
end
