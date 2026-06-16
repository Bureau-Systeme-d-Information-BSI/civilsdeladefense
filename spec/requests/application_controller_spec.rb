# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ApplicationController" do
  describe "#basic_auth" do
    before do
      allow(Altcha).to receive(:hmac_key).and_return("test-hmac-key")
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("BASIC_AUTH").and_return("user:secret")
      perform
    end

    context "with valid credentials" do
      subject(:perform) do
        get altcha_path, headers: {
          "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials("user", "secret")
        }
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context "without credentials" do
      subject(:perform) { get altcha_path }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe "#layout_by_resource" do
    context "with a non-administrator devise controller" do
      subject(:perform) { get new_user_session_path }

      before { perform }

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
