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
    subject(:create_request) { post admin_settings_administrators_path, params: params }

    context "when the admin is valid" do
      let(:params) {
        {
          administrator: attributes_for(:administrator)
        }
      }

      it "creates the administrator" do
        expect { create_request }.to change(Administrator, :count).by(1)
      end

      it "redirects to admin settings" do
        expect(create_request).to redirect_to(admin_settings_root_path)
      end
    end

    context "when the admin is invalid" do
      let(:params) {
        {
          administrator: {title: "title"}
        }
      }

      it "doesn't create the administrator" do
        expect { create_request }.not_to change(Administrator, :count)
      end

      it "renders the new template" do
        expect(create_request).to render_template(:new)
      end
    end
  end

  describe "PUT /admin/parametres/administrateurs/:id" do
    subject(:update_request) { put admin_settings_administrator_path(administrator), params: params }

    let(:administrator) { create(:administrator) }
    let(:new_employer) { create(:employer) }
    let(:params) {
      {
        administrator: {employer_id: new_employer.id}
      }
    }

    context "when the administrator is valid" do
      it "updates the administrator" do
        expect { update_request }.to change { administrator.reload.employer }.to(new_employer)
      end

      it "redirects to admin settings" do
        expect(update_request).to redirect_to(admin_settings_root_path)
      end
    end

    context "when the administrator is invalid" do
      before { allow_any_instance_of(Administrator).to receive(:update).and_return(false) }

      it "doesn't update the administrator" do
        expect { update_request }.not_to change { administrator.reload.role }
      end

      it "renders the edit template" do
        expect(update_request).to render_template(:edit)
      end
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
end
