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

  describe "PATCH /espace-candidat/mon-compte" do
    let(:new_first_name) { "Sebastien" }
    subject(:update_request) { patch account_user_path, params: {user: {first_name: new_first_name}} }

    it "redirects to edit_account_user_path" do
      update_request
      expect(response).to redirect_to(edit_account_user_path)
    end

    it "updates the user" do
      expect { update_request }.to change { user.reload.first_name }.to(new_first_name)
    end

    it "shows an error when the user can't be updated" do
      allow_any_instance_of(User).to receive(:update).and_return(false)

      update_request
      expect(response).to render_template(:edit)
    end
  end

  describe "DELETE /espace-candidat/mon-compte" do
    subject(:destroy_request) {
      delete account_user_path, params: {
        user: {
          current_password: attributes_for(:confirmed_user)[:password]
        }
      }
    }

    it "redirects to the root path" do
      destroy_request
      expect(response).to redirect_to(root_path)
    end

    it "destroys the user" do
      expect { destroy_request }.to change { User.count }.by(-1)
    end

    it "shows an error when the user can't be destroyed" do
      allow_any_instance_of(User).to receive(:destroy_with_password).and_return(false)

      destroy_request
      expect(response).to render_template(:want_destroy)
    end
  end
end
