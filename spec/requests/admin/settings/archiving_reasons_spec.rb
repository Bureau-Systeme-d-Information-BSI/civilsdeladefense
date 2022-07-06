# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Settings::ArchivingReasonsController, type: :request do
  describe "GET /admin/parametres/archiving_reasons" do
    it "lists the archiving reasons" do
      archiving_reason = create(:archiving_reason)
      sign_in create(:administrator)

      get admin_settings_archiving_reasons_path
      expect(response.body).to include(archiving_reason.name)
    end
  end
end
