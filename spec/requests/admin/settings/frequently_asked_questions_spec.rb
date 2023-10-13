# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::FrequentlyAskedQuestions" do
  it_behaves_like "an admin setting", :frequently_asked_question, :name, "a new name"
  it_behaves_like "a movable admin setting", :frequently_asked_question
end
