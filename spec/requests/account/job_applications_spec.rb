# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::JobApplications", type: :request do
  let(:user) { create(:confirmed_user) }
  before { sign_in user }

  describe "GET /espace-candidat/mes-candidatures" do
    subject(:index_request) { get account_job_applications_path }

    it "is successful" do
      index_request
      expect(response).to be_successful
    end

    it "renders the template" do
      expect(index_request).to render_template(:index)
    end
  end

  describe "GET /espace-candidat/mes-candidatures/:id/offre" do
    let(:job_application) { create(:job_application, user: user) }
    subject(:job_offer_request) { get job_offer_account_job_application_path(job_application) }

    it "is successful" do
      job_offer_request
      expect(response).to be_successful
    end

    it "renders the template" do
      expect(job_offer_request).to render_template(:job_offer)
    end
  end
end
