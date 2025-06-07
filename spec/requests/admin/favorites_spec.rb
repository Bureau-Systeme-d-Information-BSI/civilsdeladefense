require "rails_helper"

RSpec.describe "Admin::Favorites" do
  before { sign_in create(:administrator) }

  describe "POST /admin/candidatures/:job_application_id/favorite" do
    subject(:preselect_as_favorite) do
      post admin_job_offer_job_application_favorite_path(job_application.job_offer, job_application)
    end

    let(:job_application) { create(:job_application) }

    before { preselect_as_favorite }

    it "preselects as favorite" do
      expect(job_application.reload.preselection).to eq("favorite")
      expect(response).to redirect_to(admin_job_application_path(job_application))
    end
  end

  describe "DELETE /admin/candidatures/:job_application_id/favorite" do
    subject(:unpreselect_as_favorite) do
      delete admin_job_offer_job_application_favorite_path(job_application.job_offer, job_application)
    end

    let(:job_application) { create(:job_application, preselection: "favorite") }

    before { unpreselect_as_favorite }

    it "unpreselects as favorite" do
      expect(job_application.reload.preselection).to eq("pending")
      expect(response).to redirect_to(admin_job_application_path(job_application))
    end
  end
end
