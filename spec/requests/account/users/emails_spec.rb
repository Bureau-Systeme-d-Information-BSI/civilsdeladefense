# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Users::Emails" do
  let(:user) { create(:confirmed_user) }

  before { sign_in user }

  describe "GET /espace-candidat/mon-compte/email/edit" do
    subject(:edit_request) { get edit_account_user_email_path }

    before { edit_request }

    it { expect(response).to be_successful }
  end

  describe "PATCH /espace-candidat/mon-compte/email" do
    subject(:update_request) {
      patch account_user_email_path, params: {user: {email: new_email}}
    }

    let(:new_email) { "pipo@molo.fr" }

    it { is_expected.to redirect_to(account_user_path) }

    it { expect { update_request }.to change { user.reload.unconfirmed_email }.to(new_email) }

    context "with an invalid email" do
      let(:new_email) { "pipo" }

      before { update_request }

      it { expect(response).to render_template("account/users/show") }
    end
  end
end
