# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Users", type: :request do
  let(:user) { create(:confirmed_user) }
  before { sign_in user }

  describe "GET /espace-candidat/mon-compte" do
    subject(:show_request) { get account_user_path }

    it "is successful" do
      show_request
      expect(response).to be_successful
    end

    it "shows the user" do
      show_request
      expect(response).to render_template(:show)
    end
  end
end
