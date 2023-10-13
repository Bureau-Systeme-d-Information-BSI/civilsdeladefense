# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::ForeignLanguageLevels" do
  it_behaves_like "an admin setting", :foreign_language_level, :name, "a new name"
end
