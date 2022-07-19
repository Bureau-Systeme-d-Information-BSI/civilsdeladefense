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
      expect(show_request).to render_template(:show)
    end
  end

  describe "GET /espace-candidat/mon-compte/photo" do
    let(:user) { create(:confirmed_user, :with_photo) }
    subject(:photo_request) { get photo_account_user_path(user) }

    it "is successful" do
      photo_request
      expect(response).to be_successful
    end

    it "shows the administrator photo" do
      photo_request
      expect(response.headers["Content-Type"]).to eq("image/jpg")
    end
  end

  describe "PATCH /espace-candidat/mon-compte" do
    let(:new_first_name) { "Sebastien" }
    subject(:update_request) { patch account_user_path, params: {user: {first_name: new_first_name}} }

    it "redirects to edit_account_user_path" do
      expect(update_request).to redirect_to(edit_account_user_path)
    end

    it "updates the user" do
      expect { update_request }.to change { user.reload.first_name }.to(new_first_name)
    end

    it "shows an error when the user can't be updated" do
      allow_any_instance_of(User).to receive(:update).and_return(false)

      expect(update_request).to render_template(:edit)
    end
  end

  describe "PATCH /espace-candidat/mon-compte/set_password" do
    let(:new_password) { "An awesomly strong passw0rd!" }
    subject(:update_password_request) {
      patch set_password_account_user_path, params: {
        user: {
          password: new_password,
          password_confirmation: new_password
        }
      }
    }

    it "redirects to account_user_path" do
      expect(update_password_request).to redirect_to(account_user_path)
    end

    it "updates the user's password" do
      expect { update_password_request }.to change { user.reload.password }
    end

    it "shows an error when the user is invalid" do
      allow_any_instance_of(User).to receive(:update).and_return(false)

      expect(update_password_request).to render_template(:show)
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
      expect(destroy_request).to redirect_to(root_path)
    end

    it "destroys the user" do
      expect { destroy_request }.to change { User.count }.by(-1)
    end

    it "shows an error when the user can't be destroyed" do
      allow_any_instance_of(User).to receive(:destroy_with_password).and_return(false)

      expect(destroy_request).to render_template(:want_destroy)
    end
  end
end
