# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Bops", type: :request do
  it_behaves_like "an admin setting", :bop, :name, "a new name"
  it_behaves_like "a movable admin setting", :bop
end
