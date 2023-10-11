# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Employers" do
  it_behaves_like "an admin setting", :employer, :name, "a new name"
end
