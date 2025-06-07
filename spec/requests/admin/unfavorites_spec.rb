require "rails_helper"

RSpec.describe "Admin::Unfavorites" do
  before { sign_in create(:administrator) }

  describe "POST /admin/candidatures/:job_application_id/unfavorite" do
    subject(:preselect_as_unfavorite) do
      post admin_job_offer_job_application_unfavorite_path(job_application.job_offer, job_application)
    end

    let(:job_application) { create(:job_application) }

    before { preselect_as_unfavorite }

    it "preselects as unfavorite" do
      expect(job_application.reload.preselection).to eq("unfavorite")
      expect(response).to redirect_to(admin_job_application_path(job_application))
    end
  end

  describe "DELETE /admin/candidatures/:job_application_id/unfavorite" do
    subject(:unpreselect_as_unfavorite) do
      delete admin_job_offer_job_application_unfavorite_path(job_application.job_offer, job_application)
    end

    let(:job_application) { create(:job_application, preselection: "unfavorite") }

    before { unpreselect_as_unfavorite }

    it "unpreselects as unfavorite" do
      expect(job_application.reload.preselection).to eq("pending")
      expect(response).to redirect_to(admin_job_application_path(job_application))
    end
  end
end
