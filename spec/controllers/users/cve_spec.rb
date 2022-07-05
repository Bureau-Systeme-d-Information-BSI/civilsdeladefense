# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CVE-2015-9284", type: :request do
  describe "GET /auth/:provider" do
    it do
      get "/users/auth/france_connect"
      expect(response).not_to have_http_status(:redirect)
    end
  end

  describe "POST /auth/:provider without CSRF token" do
    let!(:allow_forgery_protection) { ActionController::Base.allow_forgery_protection }

    before { ActionController::Base.allow_forgery_protection = true }

    after { ActionController::Base.allow_forgery_protection = allow_forgery_protection }

    it do
      expect {
        post "/users/auth/france_connect"
      }.to raise_error(ActionController::InvalidAuthenticityToken)
    end
  end
end
