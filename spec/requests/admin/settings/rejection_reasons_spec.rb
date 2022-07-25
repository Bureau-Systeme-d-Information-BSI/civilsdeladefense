# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::RejectionReasons", type: :request do
  it_behaves_like "an admin setting", :rejection_reason, :name, "a new name"
  it_behaves_like "a movable admin setting", :rejection_reason
end
