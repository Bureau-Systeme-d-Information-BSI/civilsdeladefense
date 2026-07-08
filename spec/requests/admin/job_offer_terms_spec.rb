# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobOfferTerms" do
  describe "GET /admin/job_offer_terms" do
    subject(:index_request) { get admin_job_offer_terms_path }

    before do
      sign_in create(:administrator)
      index_request
    end

    it { expect(response).to have_http_status(:ok) }
  end
end
