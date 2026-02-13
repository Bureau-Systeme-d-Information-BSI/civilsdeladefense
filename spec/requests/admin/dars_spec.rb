require "rails_helper"

RSpec.describe "Admin::Dars" do
  before { sign_in admin }

  describe "PATCH /admin/candidatures/:job_application_id/dar" do
    subject(:update_dar) do
      patch admin_job_application_dar_path(job_application), params: {job_application: {dar: true}}, as: :turbo_stream
    end

    let(:job_application) { create(:job_application, dar: false) }

    before { job_application.job_offer.job_offer_actors.create!(role: :employer, administrator: admin) }

    context "when the administrator is employment authority" do
      let(:admin) { create(:administrator, roles: [:employment_authority]) }

      it "changes the dar value" do
        expect { update_dar }.to change { job_application.reload.dar }.from(false).to(true)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(flash[:notice]).to eq(I18n.t("admin.dars.update.success"))
      end
    end

    context "when the administrator is not employment authority" do
      let(:admin) { create(:administrator) }

      it { expect { update_dar }.not_to change { job_application.reload.dar } }
    end
  end
end
