# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers::Actors" do
  before { sign_in create(:administrator) }

  describe "GET /admin/offresdemploi/actors/new" do
    before { new_request }

    let(:job_offer) { create(:job_offer) }
    let(:administrator) { create(:administrator) }

    context "with a known administrator email" do
      subject(:new_request) do
        get new_admin_job_offers_actor_path, params: {job_offer_id: job_offer.id, email: administrator.email, role: "employer"}
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template(:new) }
    end

    context "with an upcase administrator email" do
      subject(:new_request) do
        get new_admin_job_offers_actor_path, params: {job_offer_id: job_offer.id, email: administrator.email.upcase, role: "employer"}
      end

      it { expect(response).to be_successful }
    end

    context "without a job_offer_id" do
      subject(:new_request) do
        get new_admin_job_offers_actor_path, params: {email: administrator.email, role: "employer"}
      end

      it { expect(response).to be_successful }
    end

    context "with an unknown email" do
      subject(:new_request) do
        get new_admin_job_offers_actor_path, params: {job_offer_id: job_offer.id, email: "pipo"}, xhr: true
      end

      it { expect(response).to have_http_status(:unprocessable_content) }

      it { expect(response).to render_template(:new_error) }
    end
  end
end
