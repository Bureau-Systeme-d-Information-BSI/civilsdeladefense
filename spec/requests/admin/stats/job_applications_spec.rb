# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Stats::JobApplications" do
  before { sign_in create(:administrator) }

  describe "GET /admin/stats/job_applications" do
    context "when the format is html" do
      subject(:index_request) { get admin_stats_job_applications_path, params: params }

      shared_examples "a successful request" do |prms|
        let(:params) { prms }

        it { expect { index_request }.not_to raise_error }

        it { expect(index_request).to render_template(:index) }
      end

      context "when there is no search query" do
        it_behaves_like "a successful request", nil
      end

      context "when there is a search query" do
        it_behaves_like "a successful request", {s: "hello"}
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
