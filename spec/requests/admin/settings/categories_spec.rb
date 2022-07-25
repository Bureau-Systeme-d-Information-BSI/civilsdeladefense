# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Categories", type: :request do
  it_behaves_like "an admin setting", :category, :name, "a new name"
end
