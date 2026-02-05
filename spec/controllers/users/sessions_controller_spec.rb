# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::SessionsController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "DELETE #destroy" do
    context "when user is connected with FranceConnect" do
      let(:user) { create(:confirmed_user) }
      let(:id_token) { "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.test_token" }

      before do
        create(:omniauth_information, user: user, id_token: id_token)
        sign_in user
        session[:connected_with] = "france_connect"
      end

      it "redirects to FranceConnect logout endpoint" do
        delete :destroy

        expect(response.location).to include("#{ENV.fetch("FRANCE_CONNECT_HOST")}/api/v2/session/end")
      end

      it "includes id_token_hint in the redirect URL" do
        delete :destroy

        expect(response.location).to include("id_token_hint=#{id_token}")
      end

      it "includes post_logout_redirect_uri in the redirect URL" do
        delete :destroy

        expect(response.location).to include("post_logout_redirect_uri=")
      end

      it "includes state in the redirect URL" do
        delete :destroy

        expect(response.location).to include("state=")
      end

      it "signs out the user locally" do
        delete :destroy

        expect(controller.current_user).to be_nil
      end
    end

    context "when user is connected without FranceConnect" do
      let(:user) { create(:confirmed_user) }

      before { sign_in user }

      it "redirects to root path" do
        delete :destroy

        expect(response).to redirect_to(root_path)
      end

      it "signs out the user" do
        delete :destroy

        expect(controller.current_user).to be_nil
      end
    end

    context "when user has FranceConnect link but no id_token" do
      let(:user) { create(:confirmed_user) }

      before do
        create(:omniauth_information, user: user, id_token: nil)
        sign_in user
        session[:connected_with] = "france_connect"
      end

      it "redirects to root path (standard logout)" do
        delete :destroy

        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is connected with FranceConnect but session flag is missing" do
      let(:user) { create(:confirmed_user) }
      let(:id_token) { "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.test_token" }

      before do
        create(:omniauth_information, user: user, id_token: id_token)
        sign_in user
        # No session[:connected_with] flag
      end

      it "redirects to root path (standard logout)" do
        delete :destroy

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
