# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::Administrators", type: :request do
  let(:administrator) { create(:administrator) }
  before { sign_in administrator }

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
end
