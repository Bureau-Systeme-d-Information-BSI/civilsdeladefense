# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::JobApplication::Users" do
  let(:administrator) { create(:administrator) }
  let(:user) { create(:user, phone: "0612345678") }
  let(:job_application) { create(:job_application, user:) }

  before { sign_in administrator }

  describe "PATCH /admin/candidatures/:job_application_id/user" do
    subject(:update_request) { patch admin_job_application_user_path(job_application), params: {user: user_params}, xhr: }

    let(:xhr) { false }

    context "with valid params" do
      let(:user_params) { {phone: "0712345678"} }

      context "when format is HTML" do
        it { expect(update_request).to redirect_to(admin_job_application_path(job_application)) }

        it { expect { update_request }.to change { user.reload.phone }.to("+33712345678") }
      end

      context "when format is JS" do
        let(:xhr) { true }

        it { expect(update_request).to render_template(:update) }

        it { expect { update_request }.to change { user.reload.phone }.to("+33712345678") }
      end
    end

    context "with invalid params" do
      let(:user_params) { {phone: ""} }

      before { update_request }

      context "when format is HTML" do
        it { expect(flash[:alert]).to be_present }
      end

      context "when format is JS" do
        let(:xhr) { true }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end

    context "when the administrator cannot update_user_info" do
      let(:user_params) { {phone: "0712345678"} }

      before { allow_any_instance_of(Administrator).to receive(:can?).and_return(false) }

      it "returns forbidden and does not update the user" do
        expect { update_request }.not_to change { user.reload.phone }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
