# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers::Archives" do
  describe "GET /admin/offresdemploi/archives" do
    subject(:archives_request) { get admin_job_offers_archives_path }

    before do
      sign_in create(:administrator)
      create(:archived_job_offer)
    end

    context "when the administrator can read job offers" do
      before { archives_request }

      it { expect(response).to be_successful }
    end

    context "when the administrator cannot read job offers" do
      before do
        allow_any_instance_of(Ability).to receive(:can?).and_return(false)
        archives_request
      end

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
