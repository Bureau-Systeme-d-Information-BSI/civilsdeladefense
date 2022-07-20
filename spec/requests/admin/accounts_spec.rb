# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Accounts", type: :request do
  let(:administrator) { create(:administrator) }

  before { sign_in administrator }

  describe "GET /admin/account/" do
    subject(:show_request) { get admin_account_path }

    it "is successful" do
      show_request
      expect(response).to be_successful
    end

    it "shows the account" do
      expect(show_request).to render_template(:show)
    end
  end

  describe "GET /admin/account/photo" do
    subject(:photo_request) { get photo_admin_account_path(id: administrator.id) }

    let(:administrator) { create(:administrator, :with_photo) }

    it "is successful" do
      photo_request
      expect(response).to be_successful
    end

    it "shows the administrator photo" do
      photo_request
      expect(response.headers["Content-Type"]).to eq("image/jpeg")
    end
  end

  describe "PATCH /admin/account/" do
    subject(:update_request) {
      patch admin_account_path, params: {administrator: {first_name: new_first_name}}
    }

    let(:new_first_name) { "Sebastien" }

    it "redirects to admin_account_path" do
      expect(update_request).to redirect_to(admin_account_path)
    end

    it "updates the account" do
      expect { update_request }.to change { administrator.reload.first_name }.to(new_first_name)
    end

    it "shows an error when the account is invalid" do
      allow_any_instance_of(Administrator).to receive(:update).and_return(false)

      expect(update_request).to render_template(:show)
    end
  end

  describe "PATCH /admin/account/update_email" do
    subject(:update_email_request) {
      patch update_email_admin_account_path, params: {administrator: {email: new_email}}
    }

    let(:new_email) { "test@example.com" }

    it "redirects to change_email_admin_account" do
      expect(update_email_request).to redirect_to(change_email_admin_account_path)
    end

    it "updates the administrator's unconfirmed_email" do
      expect { update_email_request }.to change { administrator.reload.unconfirmed_email }.to(new_email)
    end

    it "shows an error when the account is invalid" do
      allow_any_instance_of(Administrator).to receive(:update).and_return(false)

      expect(update_email_request).to render_template(:change_email)
    end

    describe "PATCH /admin/account/update_password" do
      subject(:update_password_request) {
        patch update_password_admin_account_path, params: {
          administrator: {
            current_password: attributes_for(:administrator)[:password],
            password: new_password,
            password_confirmation: new_password
          }
        }
      }

      let(:new_password) { "A perflectly plausible password 1234!" }

      it "redirects to change_password_admin_account_path" do
        expect(update_password_request).to redirect_to(change_password_admin_account_path)
      end

      it "updates the administrator's password" do
        expect { update_password_request }.to change { administrator.reload.password }
      end

      it "shows an error when the account is invalid" do
        allow_any_instance_of(Administrator).to receive(:update).and_return(false)

        expect(update_password_request).to render_template(:change_password)
      end
    end
  end
end
