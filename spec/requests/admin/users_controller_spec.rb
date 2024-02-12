# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::UsersController do
  describe "DELETE /admins/candidats/:id" do
    it "destroys the user and redirects to index" do
      sign_in create(:administrator)

      user = create(:confirmed_user)
      delete admin_user_path(user)

      expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
      expect(response).to redirect_to(admin_users_path)
    end
  end
end
