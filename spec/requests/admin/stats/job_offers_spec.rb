# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Stats::JobOffers" do
  before { sign_in create(:administrator) }

  describe "GET /admin/stats/job_offers" do
    context "when the format is html" do
      subject(:index_request) { get admin_stats_job_offers_path, params: {s: "foo"} }

      it "renders the template" do
        expect(index_request).to render_template(:index)
      end
    end

    context "when the format is xlsx" do
      subject(:index_request) { get admin_stats_job_offers_path(format: :xlsx), params: {s: "foo"} }

      it "exports the stats as a xlsx file" do
        index_request
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end
  end
end
