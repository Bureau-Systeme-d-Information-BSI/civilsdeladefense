require 'rails_helper'

RSpec.describe "Admin::Settings::Categories", type: :request do
  describe "GET /admin/settings/categories" do
    it "works! (now write some real specs)" do
      admin = create(:administrator)
      admin.confirm
      sign_in admin
      get admin_settings_categories_path
      expect(response).to have_http_status(200)
    end
  end
end
