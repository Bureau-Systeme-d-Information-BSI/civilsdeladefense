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
    subject(:update) { put :update, params: {id: user.to_param, user: user_params} }

    context "with valid params" do
      let(:user_params) { {phone: "0712345678"} }

      it "updates the requested user" do
        update
        user.reload
        expect(user.phone).to eq("+33712345678")
      end
    end

    context "with invalid params" do
      let(:user_params) { {phone: ""} }

      it "returns a success response (i.e. to display the 'edit' template)" do
        update
        expect(response).to be_successful
      end
    end
  end
end
