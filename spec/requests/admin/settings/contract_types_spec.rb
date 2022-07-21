# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::ContractTypes", type: :request do
  it_behaves_like "an admin setting", :contract_type, :name, "a new name"
  it_behaves_like "a movable admin setting", :contract_type
end
