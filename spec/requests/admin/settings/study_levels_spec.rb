# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::StudyLevels", type: :request do
  it_behaves_like "an admin setting", :study_level, :name, "a new name"
  it_behaves_like "a movable admin setting", :study_level
end
