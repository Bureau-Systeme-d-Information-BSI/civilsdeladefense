# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Sectors" do
  it_behaves_like "an admin setting", :sector, :name, "a new name"
  it_behaves_like "a movable admin setting", :sector
end
