# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Administrators::Activations" do
  before { sign_in create(:administrator) }

  describe "POST /admin/parametres/administrateurs/:administrator_id/activation" do
    subject(:create_request) { post admin_settings_administrator_activation_path(administrator) }

    let(:administrator) { create(:administrator) }

    it "deactivates the administrator" do
      expect { create_request }.to change { administrator.reload.inactive? }.to(true)
    end

    it "redirects to settings root" do
      expect(create_request).to redirect_to(admin_settings_root_path)
    end
  end

  describe "DELETE /admin/parametres/administrateurs/:administrator_id/activation" do
    subject(:destroy_request) { delete admin_settings_administrator_activation_path(administrator) }

    let(:administrator) { create(:administrator, :deactivated) }

    it "reactivates the administrator" do
      expect { destroy_request }.to change { administrator.reload.active? }.to(true)
    end

    it "redirects to settings root" do
      expect(destroy_request).to redirect_to(admin_settings_root_path)
    end
  end
end
