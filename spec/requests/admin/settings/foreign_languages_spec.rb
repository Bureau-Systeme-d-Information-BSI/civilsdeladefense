# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::ForeignLanguages", type: :request do
  it_behaves_like "an admin setting", :foreign_language, :name, "a new name"
  it_behaves_like "a movable admin setting", :foreign_language
end
