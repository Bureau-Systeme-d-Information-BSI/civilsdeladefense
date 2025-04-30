require "rails_helper"

RSpec.describe "Admin::Rejections" do
  let(:administrator) { create(:administrator) }

  before { sign_in administrator }

  describe "POST /admin/job_applications/:id/rejections" do
    subject(:rejection) { post admin_job_application_rejections_path(job_application), params: }

    let(:job_application) { create(:job_application) }
    let(:params) { {job_application: {rejection_reason_id: create(:rejection_reason).id}} }

    it { expect(rejection).to redirect_to(admin_job_application_path(job_application)) }
  end
end
