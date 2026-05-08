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
end
