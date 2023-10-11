# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Pages" do
  it_behaves_like "an admin setting", :page, :og_title, "a new title"
end
