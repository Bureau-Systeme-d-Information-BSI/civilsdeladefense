# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::UsersController do
  let(:user) { create(:user) }

  login_admin

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: user.to_param}
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    subject(:update) {
      put :update, params: {id: user.to_param, user: user_params}, format: format
    }

    context "with valid params" do
      let(:user_params) { {phone: "07"} }

      context "when format is HTML" do
        let(:format) { :html }

        it "updates the requested user" do
          update
          user.reload
          expect(user.phone).to eq("07")
        end
      end

      context "when format is JS" do
        let(:format) { :js }

        it "updates the requested user" do
          update
          user.reload
          expect(user.phone).to eq("07")
        end
      end
    end

    context "with invalid params" do
      let(:user_params) { {phone: ""} }

      context "when format is HTML" do
        let(:format) { :html }

        it "returns a success response (i.e. to display the 'edit' template)" do
          update
          expect(response).to be_successful
        end
      end

      context "when format is JS" do
        let(:format) { :js }

        it "returns unprocessable_entity" do
          update
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
