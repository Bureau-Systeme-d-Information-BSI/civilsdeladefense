# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Administrators" do
  before { sign_in create(:administrator) }

  describe "GET /admin/parametres/administrateurs" do
    subject(:index_request) { get admin_settings_administrators_path }

    it "is successful" do
      index_request
      expect(response).to be_successful
    end

    it "renders the template" do
      expect(index_request).to render_template(:index)
    end
  end

  describe "GET /admin/parametres/administrateurs/inactive" do
    subject(:inactive_request) { get inactive_admin_settings_administrators_path }

    it "is successful" do
      inactive_request
      expect(response).to be_successful
    end

    it "renders the template" do
      expect(inactive_request).to render_template(:index)
    end
  end

  describe "GET /admin/parametres/administrateurs/export" do
    subject(:export_request) { get export_admin_settings_administrators_path, params: {active: true} }

    it "exports the administrators as an xlsx file" do
      export_request
      expect(response.headers["Content-Type"]).to eq(
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
    end

    context "when an administrator doesn't have any inviter" do
      it "doesn't raise an error" do
        create(:administrator, inviter: nil)
        expect { export_request }.not_to raise_error
      end
    end
  end

  describe "POST /admin/parametres/administrateurs" do
    subject(:create_request) { post admin_settings_administrators_path, params: }

    context "when the admin is valid" do
      let(:params) {
        {
          administrator: {
            title: "title",
            first_name: "first_name",
            last_name: "last_name",
            email: "email@example.com",
            employer_ids: [first_employer.id, second_employer.id]
          }
        }
      }
      let(:employer_ids) { [first_employer.id, second_employer.id] }
      let(:first_employer) { create(:employer) }
      let(:second_employer) { create(:employer) }

      it { expect { create_request }.to change(Administrator, :count).by(1) }

      describe "created administrator" do
        let(:admin) { Administrator.order(:created_at).last }

        before { create_request }

        it { expect(admin.title).to eq("title") }
        it { expect(admin.first_name).to eq("first_name") }
        it { expect(admin.last_name).to eq("last_name") }
        it { expect(admin.email).to eq("email@example.com") }
        it { expect(admin.employers).to contain_exactly(first_employer, second_employer) }
      end

      it { expect(create_request).to redirect_to(admin_settings_root_path) }
    end

    context "when the admin is invalid" do
      let(:params) { {administrator: {title: "title"}} }

      it { expect { create_request }.not_to change(Administrator, :count) }

      it { expect(create_request).to render_template(:new) }
    end
  end

  describe "PUT /admin/parametres/administrateurs/:id" do
    subject(:update_request) { put admin_settings_administrator_path(administrator), params: }

    let(:administrator) { create(:administrator) }
    let(:new_employer) { create(:employer) }
    let(:params) {
      {
        administrator: {
          first_name: "first",
          last_name: "last",
          email: "email@example.com",
          title: "title",
          employer_id: new_employer.id,
          employer_ids: [new_employer.id]
        }
      }
    }

    context "when the administrator is valid" do
      it { expect { update_request }.to change { administrator.reload.title }.to("title") }

      it { expect { update_request }.to change { administrator.reload.first_name }.to("first") }

      it { expect { update_request }.to change { administrator.reload.last_name }.to("last") }

      it { expect { update_request }.to change { administrator.reload.unconfirmed_email }.to("email@example.com") }

      it { expect { update_request }.to change { administrator.reload.employer }.to(new_employer) }

      it { expect { update_request }.to change { administrator.reload.employers }.to([new_employer]) }

      it { expect(update_request).to redirect_to(admin_settings_root_path) }
    end

    context "when the administrator is invalid" do
      before { allow_any_instance_of(Administrator).to receive(:update).and_return(false) }

      it { expect { update_request }.not_to change { administrator.reload.role } }

      it { expect(update_request).to render_template(:edit) }
    end
  end

  describe "POST /admin/parametres/administrateurs/:id/send_unlock_instructions" do
    subject(:send_unlock_instructions_request) {
      post send_unlock_instructions_admin_settings_administrator_path(administrator)
    }

    let(:administrator) { create(:administrator) }

    it "sends the unlock instructions" do
      expect { send_unlock_instructions_request }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "redirects to admin settings" do
      expect(send_unlock_instructions_request).to redirect_to(admin_settings_root_path)
    end
  end

  describe "POST /admin/parametres/administrateurs/:id/resend_confirmation_instructions" do
    subject(:resend_confirmation_instructions_request) {
      post resend_confirmation_instructions_admin_settings_administrator_path(administrator)
    }

    let(:administrator) { create(:administrator) }

    it "sends the unlock instructions" do
      expect { resend_confirmation_instructions_request }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "redirects to admin settings" do
      expect(resend_confirmation_instructions_request).to redirect_to(admin_settings_root_path)
    end
  end

  describe "POST /admin/parametres/administrateurs/:id/deactivate" do
    subject(:deactivate_request) { post deactivate_admin_settings_administrator_path(administrator) }

    let(:administrator) { create(:administrator) }

    it "deactivates the administrator" do
      expect { deactivate_request }.to change { administrator.reload.inactive? }.to(true)
    end

    it "redirects to admin settings" do
      expect(deactivate_request).to redirect_to(admin_settings_root_path)
    end
  end

  describe "POST /admin/parametres/administrateurs/:id/reactivate" do
    subject(:reactivate_request) { post reactivate_admin_settings_administrator_path(administrator) }

    let(:administrator) { create(:administrator, :deactivated) }

    it "reactivates the administrator" do
      expect { reactivate_request }.to change { administrator.reload.active? }.to(true)
    end

    it "redirects to admin settings" do
      expect(reactivate_request).to redirect_to(admin_settings_root_path)
    end
  end

  describe "POST /admin/parametres/administrateurs/:id/transfer" do
    subject(:transfer_request) {
      post transfer_admin_settings_administrator_path(administrator), params: {transfer_email: transfer_email}
    }

    let(:administrator) { create(:administrator) }
    let(:transfer_email) { "an.email.adress@example.com" }

    context "when the transfer persisted" do
      it "redirects to admin settings" do
        expect(transfer_request).to redirect_to(admin_settings_root_path)
      end
    end

    context "when the transfer did not persist" do
      before { allow_any_instance_of(Administrator).to receive(:persisted?).and_return(false) }

      it "redirects to the edit administrator settings" do
        expect(transfer_request).to redirect_to(edit_admin_settings_administrator_path(administrator))
      end
    end
  end

  describe "DELETE /admin/parametres/administrateurs/:id" do
    subject(:destroy_request) { delete admin_settings_administrator_path(administrator), xhr: true }

    let!(:administrator) { create(:administrator) }

    it { expect { destroy_request }.to change(Administrator, :count).by(-1) }

    describe "response" do
      before { destroy_request }

      it { expect(response).to be_successful }
      it { expect(response).to render_template(:destroy) }
    end
  end
end
