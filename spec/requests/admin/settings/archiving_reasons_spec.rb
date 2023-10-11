# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::ArchivingReasons" do
  it_behaves_like "an admin setting", :archiving_reason, :name, "a new name"
  it_behaves_like "a movable admin setting", :archiving_reason
end
