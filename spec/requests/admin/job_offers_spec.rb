# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers", type: :request do
  before { sign_in create(:administrator) }

  describe "POST /admin/offresdemploi/exports" do
    let(:job_offer_ids) { create_list(:job_offer, 2) }

    context "when a job_offer_ids list is provided" do
      it "export the job offers" do
        post exports_admin_job_offers_path, params: {job_offer_ids: job_offer_ids}
        expect(response).to be_successful
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end

    context "when selecting all job offers" do
      it "export the job offers" do
        post exports_admin_job_offers_path, params: {select_all: "on"}
        expect(response).to be_successful
        expect(response.headers["Content-Type"]).to eq(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end
    end
  end
end
