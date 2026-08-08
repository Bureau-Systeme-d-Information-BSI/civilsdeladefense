# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers::Exports" do
  before { sign_in create(:administrator) }

  describe "GET /admin/offresdemploi/:job_offer_id/export" do
    subject(:export_request) { get admin_job_offer_export_path(job_offer) }

    let(:job_offer) { create(:published_job_offer) }

    before do
      create(:job_application, job_offer:)
      export_request
    end

    it { expect(response).to be_successful }

    it {
      expect(response.headers["Content-Type"]).to eq(
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
    }
  end
end
