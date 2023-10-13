# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Robots" do
  describe "GET /robots" do
    it "renders the template" do
      expect(get(robots_path(format: :txt))).to render_template(:show)
    end
  end
end
