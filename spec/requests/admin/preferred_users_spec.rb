# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::PreferredUsers", type: :request do
  let(:preferred_user) { create(:preferred_user) }
  let(:user) { preferred_user.user }
  let(:preferred_users_list) { preferred_user.preferred_users_list }

  before { sign_in preferred_users_list.administrator }

  describe "GET /destroy" do
    subject(:destroy_request) { delete admin_preferred_user_path(preferred_user) }

    it "removes user from the list and redirects to the list" do
      destroy_request
      expect(response).to redirect_to(admin_preferred_users_list_path(preferred_users_list))
      expect(preferred_users_list.users).not_to include(user)
    end

    it "redirects if the preferred user can't be destroyed" do
      allow_any_instance_of(PreferredUser).to receive(:destroy).and_return(false)

      destroy_request
      expect(response).to redirect_to(admin_preferred_users_list_path(preferred_users_list))
      expect(preferred_users_list.users).to include(user)
    end
  end
end
