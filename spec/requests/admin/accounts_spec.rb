# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::AccountsController do
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
    subject(:update_request) { patch admin_account_path, params: }

    let(:params) do
      {
        administrator: {
          first_name:,
          current_password: attributes_for(:administrator)[:password],
          password: new_password,
          password_confirmation: new_password,
          email:,
          title:
        }
      }
    end
    let(:first_name) { "Sebastien" }
    let(:new_password) { "A perflectly plausible password 1234!" }
    let(:email) { "new_email@example.com" }
    let(:title) { "Functional Administrator" }

    it "redirects to admin_account_path" do
      expect(update_request).to redirect_to(admin_account_path)
    end

    it "updates the account" do
      expect { update_request }.to change { administrator.reload.first_name }.to(first_name)
    end

    it "updates the administrator's password" do
      expect { update_request }.to change { administrator.reload.password }
    end

    it "shows an error when the account is invalid" do
      allow_any_instance_of(Administrator).to receive(:update).and_return(false)

      expect(update_request).to render_template(:show)
    end

    describe "email update" do
      context "when the admin is functional administrator" do
        it { expect { update_request }.to change { administrator.reload.unconfirmed_email }.to(email) }
      end

      context "when the admin is not functional administrator" do
        before { administrator.update!(roles: [:payroll_manager]) }

        it { expect { update_request }.not_to change { administrator.reload.unconfirmed_email } }
      end
    end

    describe "title update" do
      context "when the admin is functional administrator" do
        it { expect { update_request }.to change { administrator.reload.title }.to(title) }
      end

      context "when the admin is not functional administrator" do
        before { administrator.update!(roles: [:payroll_manager]) }

        it { expect { update_request }.not_to change { administrator.reload.title } }
      end
    end
  end
end
