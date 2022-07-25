# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::OrganizationDefaults", type: :request do
  it_behaves_like "an admin setting", :organization_default, :value, "a new value"
end
