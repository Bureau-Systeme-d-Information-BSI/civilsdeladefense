# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Administrators::ConfirmationInstructions" do
  before { sign_in create(:administrator) }

  describe "POST /admin/parametres/administrateurs/:administrator_id/confirmation_instruction" do
    subject(:create_request) { post admin_settings_administrator_confirmation_instruction_path(administrator) }

    let(:administrator) { create(:administrator) }

    it { expect { create_request }.to change { ActionMailer::Base.deliveries.count }.by(1) }

    it { is_expected.to redirect_to(admin_settings_root_path) }
  end
end
