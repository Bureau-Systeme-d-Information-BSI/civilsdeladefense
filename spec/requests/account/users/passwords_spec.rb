# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Users::Passwords" do
  let(:user) { create(:confirmed_user) }

  before { sign_in user }

  describe "GET /espace-candidat/mon-compte/password/edit" do
    subject(:edit_request) { get edit_account_user_password_path }

    before { edit_request }

    it { expect(response).to be_successful }
  end

  describe "PATCH /espace-candidat/mon-compte/password" do
    subject(:update_request) {
      patch account_user_password_path, params: {
        user: {
          current_password:,
          password: new_password,
          password_confirmation: new_password
        }
      }
    }

    let(:current_password) { attributes_for(:confirmed_user)[:password] }
    let(:new_password) { "An awesomly strong passw0rd!" }

    it { is_expected.to redirect_to(account_user_path) }

    it { expect { update_request }.to change { user.reload.encrypted_password } }

    context "with invalid params" do
      let(:current_password) { "wrong password" }

      before { update_request }

      it { expect(response).to render_template("account/users/show") }
    end
  end
end
