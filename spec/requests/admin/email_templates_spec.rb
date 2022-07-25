# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::EmailTemplates", type: :request do
  describe "GET /admin/email_templates" do
    it "renders the requested email template" do
      email_template = create(:email_template)
      sign_in create(:administrator)

      get admin_email_templates_path, params: {email: {template: email_template.id}}
      expect(response.body).to eq(email_template.to_json)
    end
  end
end
