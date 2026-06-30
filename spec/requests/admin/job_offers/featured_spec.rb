# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers::Featured" do
  describe "GET /admin/offresdemploi/featured" do
    subject(:featured_request) { get admin_job_offers_featured_path }

    before do
      sign_in create(:administrator)
      create(:published_job_offer, featured: true)
    end

    context "when the administrator can feature job offers" do
      before { featured_request }

      it { expect(response).to be_successful }
    end

    context "when the administrator cannot feature job offers" do
      before do
        allow_any_instance_of(Ability).to receive(:can?).and_return(false)
        featured_request
      end

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
