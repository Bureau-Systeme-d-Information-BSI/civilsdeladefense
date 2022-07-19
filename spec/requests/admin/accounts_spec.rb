# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Accounts", type: :request do
  let(:administrator) { create(:administrator) }
  before { sign_in administrator }

  describe "GET /admin/account/" do
    it "is successful" do
      get admin_account_path
      expect(response).to be_successful
    end

    it "shows the account" do
      get admin_account_path
      expect(response).to render_template(:show)
    end
  end

  describe "GET /admin/account/photo" do
    let(:administrator) { create(:administrator, :with_photo) }

    it "is successful" do
      get photo_admin_account_path(id: administrator.id)
      expect(response).to be_successful
    end

    it "shows the administrator photo" do
      get photo_admin_account_path(id: administrator.id)
      expect(response.headers["Content-Type"]).to eq("image/jpeg")
    end
  end

  describe "PATCH /admin/account/" do
    let(:new_first_name) { "Sebastien" }
    subject(:update_request) {
      patch admin_account_path, params: {administrator: {first_name: new_first_name}}
    }

    it "redirects to admin_account_path" do
      update_request
      expect(response).to redirect_to(admin_account_path)
    end

    it "updates the account" do
      expect { update_request }.to change { administrator.reload.first_name }.to(new_first_name)
    end

    it "shows an error when the account is invalid" do
      allow_any_instance_of(Administrator).to receive(:update).and_return(false)

      update_request
      expect(response).to render_template(:show)
    end
  end

  describe "PATCH /admin/account/update_email" do
    let(:new_email) { "test@example.com" }
    subject(:update_email_request) {
      patch update_email_admin_account_path, params: {administrator: {email: new_email}}
    }

    it "redirects to change_email_admin_account" do
      update_email_request
      expect(response).to redirect_to(change_email_admin_account_path)
    end

    it "updates the administrator's unconfirmed_email" do
      expect { update_email_request }.to change { administrator.reload.unconfirmed_email }.to(new_email)
    end

    it "shows an error when the account is invalid" do
      allow_any_instance_of(Administrator).to receive(:update).and_return(false)

      update_email_request
      expect(response).to render_template(:change_email)
    end

    describe "PATCH /admin/account/update_password" do
      let(:new_password) { "A perflectly plausible password 1234!" }
      subject(:update_password_request) {
        patch update_password_admin_account_path, params: {
          administrator: {
            current_password: attributes_for(:administrator)[:password],
            password: new_password,
            password_confirmation: new_password
          }
        }
      }

      it "redirects to change_password_admin_account_path" do
        update_password_request
        expect(response).to redirect_to(change_password_admin_account_path)
      end

      it "updates the administrator's password" do
        expect { update_password_request }.to change { administrator.reload.password }
      end

      it "shows an error when the account is invalid" do
        allow_any_instance_of(Administrator).to receive(:update).and_return(false)

        update_password_request
        expect(subject).to render_template(:change_password)
      end
    end
  end
end
