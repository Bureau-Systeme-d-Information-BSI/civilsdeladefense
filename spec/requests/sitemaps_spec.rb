# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sitemaps", type: :request do
  describe "GET /sitemaps" do
    it "renders the template" do
      create(:published_job_offer)
      expect(get(sitemap_path(format: :xml))).to render_template(:show)
    end
  end
end
