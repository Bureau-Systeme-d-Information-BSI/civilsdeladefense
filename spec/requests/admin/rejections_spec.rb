require "rails_helper"

RSpec.describe "Admin::Rejections" do
  let(:administrator) { create(:administrator) }
  let(:job_application) { create(:job_application) }

  before { sign_in administrator }

  describe "GET /admin/job_applications/:id/rejections/new" do
    subject(:new_request) { get new_admin_job_application_rejection_path(job_application), xhr: true }

    before { new_request }

    it { expect(response).to be_successful }
  end

  describe "POST /admin/job_applications/:id/rejections" do
    subject(:rejection) { post admin_job_application_rejection_path(job_application), params: }

    let(:params) { {job_application: {rejection_reason_id: create(:rejection_reason).id}} }

    context "when administrator can update_application_rejected" do
      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(true) }

      it { expect(rejection).to redirect_to(admin_job_application_path(job_application)) }
    end

    context "when administrator cannot update_application_rejected" do
      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(false) }

      it "redirects with an unauthorized notification and does not reject the job application" do
        expect { rejection }.not_to change { job_application.reload.rejected }
        expect(response).to redirect_to(admin_job_application_path(job_application))
        expect(flash[:notice]).to eq(I18n.t("admin.rejections.create.unauthorized"))
      end
    end
  end

  describe "DELETE /admin/job_applications/:id/rejections" do
    subject(:unrejection) { delete admin_job_application_rejection_path(job_application) }

    before { job_application.update!(rejected: true, rejection_reason: create(:rejection_reason)) }

    context "when administrator can update_application_rejected" do
      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(true) }

      it { expect(unrejection).to redirect_to(admin_job_application_path(job_application)) }
    end

    context "when administrator cannot update_application_rejected" do
      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(false) }

      it "redirects with an unauthorized notification and does not unreject the job application" do
        expect { unrejection }.not_to change { job_application.reload.rejected }
        expect(response).to redirect_to(admin_job_application_path(job_application))
        expect(flash[:notice]).to eq(I18n.t("admin.rejections.destroy.unauthorized"))
      end
    end
  end
end
