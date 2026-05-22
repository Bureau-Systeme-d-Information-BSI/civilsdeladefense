# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Users::Suspensions" do
  let(:admin) { create(:administrator) }
  let(:user) { create(:confirmed_user) }

  before { sign_in admin }

  describe "POST /admin/candidats/:user_id/suspension" do
    subject(:create_request) {
      post admin_user_suspension_path(user), params: {user: {suspension_reason: "Raison"}}
    }

    it "suspends the user" do
      expect { create_request }.to change { user.reload.suspended? }.to(true)
    end

    it "redirects to the user" do
      expect(create_request).to redirect_to(admin_user_path(user))
    end
  end

  describe "DELETE /admin/candidats/:user_id/suspension" do
    subject(:destroy_request) { delete admin_user_suspension_path(user) }

    before { user.suspend! }

    it "unsuspends the user" do
      expect { destroy_request }.to change { user.reload.suspended? }.to(false)
    end

    it "redirects to the user" do
      expect(destroy_request).to redirect_to(admin_user_path(user))
    end
  end
end
