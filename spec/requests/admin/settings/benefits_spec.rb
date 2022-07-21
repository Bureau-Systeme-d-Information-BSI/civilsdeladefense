# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Benefits", type: :request do
  it_behaves_like "an admin setting", :benefit, :name
  it_behaves_like "a movable admin setting", :benefit
end
