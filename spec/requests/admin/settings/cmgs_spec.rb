# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Cmgs" do
  it_behaves_like "an admin setting", :cmg, :email, "test@example.com"
end
