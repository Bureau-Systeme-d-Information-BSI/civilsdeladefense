# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::ProfessionalCategories" do
  it_behaves_like "an admin setting", :professional_category, :name, "a new name"
  it_behaves_like "a movable admin setting", :professional_category
end
