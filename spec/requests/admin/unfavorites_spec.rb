require "rails_helper"

RSpec.describe "Admin::Unfavorites" do
  before { sign_in create(:administrator) }

  describe "POST /admin/candidatures/:job_application_id/unfavorite" do
    subject(:preselect_as_unfavorite) do
      post admin_job_offer_job_application_unfavorite_path(job_application.job_offer, job_application)
    end

    let(:job_application) { create(:job_application) }

    context "when administrator can update_application_preselection" do
      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(true) }

      it "preselects as unfavorite" do
        preselect_as_unfavorite
        expect(job_application.reload.preselection).to eq("unfavorite")
        expect(response).to redirect_to(admin_job_application_path(job_application))
      end
    end

    context "when administrator cannot update_application_preselection" do
      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(false) }

      it "does not preselect and redirects back" do
        expect { preselect_as_unfavorite }.not_to change { job_application.reload.preselection }
        expect(response).to redirect_to(admin_job_application_path(job_application))
      end
    end
  end

  describe "DELETE /admin/candidatures/:job_application_id/unfavorite" do
    subject(:unpreselect_as_unfavorite) do
      delete admin_job_offer_job_application_unfavorite_path(job_application.job_offer, job_application)
    end

    let(:job_application) { create(:job_application, preselection: "unfavorite") }

    context "when administrator can update_application_preselection" do
      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(true) }

      it "unpreselects as unfavorite" do
        unpreselect_as_unfavorite
        expect(job_application.reload.preselection).to eq("pending")
        expect(response).to redirect_to(admin_job_application_path(job_application))
      end
    end

    context "when administrator cannot update_application_preselection" do
      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(false) }

      it "does not change the preselection and redirects back" do
        expect { unpreselect_as_unfavorite }.not_to change { job_application.reload.preselection }
        expect(response).to redirect_to(admin_job_application_path(job_application))
      end
    end
  end
end
