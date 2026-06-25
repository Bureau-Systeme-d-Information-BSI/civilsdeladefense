# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOffers::Dispatches" do
  before { sign_in create(:administrator) }

  let(:job_offer) { create(:job_offer) }

  describe "GET /admin/offresdemploi/:job_offer_id/dispatch/new" do
    subject(:new_request) { get new_admin_job_offer_dispatch_path(job_offer) }

    before { new_request }

    it { expect(response).to be_successful }
  end

  describe "POST /admin/offresdemploi/:job_offer_id/dispatch" do
    subject(:create_request) {
      post admin_job_offer_dispatch_path(job_offer), params: {preferred_users_lists: [preferred_users_list.id]}
    }

    let(:preferred_users_list) { create(:preferred_users_list, :with_users) }

    it { expect(create_request).to redirect_to(admin_job_offers_path) }

    it "sends the job offer to the list users" do
      expect { create_request }.to change { ActionMailer::Base.deliveries.size }.by(3)
    end
  end
end
