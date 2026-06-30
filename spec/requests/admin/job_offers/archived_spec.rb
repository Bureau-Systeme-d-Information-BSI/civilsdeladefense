# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers::Archived" do
  describe "GET /admin/offresdemploi/archived" do
    subject(:archived_request) { get admin_job_offers_archived_path }

    before do
      sign_in create(:administrator)
      create(:archived_job_offer)
    end

    context "when the administrator can read job offers" do
      before { archived_request }

      it { expect(response).to be_successful }
    end

    context "when the administrator cannot read job offers" do
      before do
        allow_any_instance_of(Ability).to receive(:can?).and_return(false)
        archived_request
      end

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
