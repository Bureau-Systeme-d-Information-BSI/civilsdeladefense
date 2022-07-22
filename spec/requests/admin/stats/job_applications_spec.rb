# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Stats::JobApplications", type: :request do
  before { sign_in create(:administrator) }

  describe "GET /admin/stats/job_applications" do
    context "when the format is html" do
      subject(:index_request) { get admin_stats_job_applications_path }

      it "renders the template" do
        expect(index_request).to render_template(:index)
      end
    end

    context "when the format is xlsx" do
      subject(:index_request) { get admin_stats_job_applications_path(format: :xlsx) }

      it "exports the stats as a xlsx file" do
        index_request
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end
  end
end
