# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::PreferredUsers", type: :request do
  let(:preferred_user) { create(:preferred_user) }
  let(:user) { preferred_user.user }
  let(:preferred_users_list) { preferred_user.preferred_users_list }

  before { sign_in preferred_users_list.administrator }

  describe "GET /destroy" do
    it "removes user from the list and redirects to the list" do
      delete admin_preferred_user_path(preferred_user)
      expect(response).to redirect_to(admin_preferred_users_list_path(preferred_users_list))
      expect(preferred_users_list.users).not_to include(user)
    end
  end
end
