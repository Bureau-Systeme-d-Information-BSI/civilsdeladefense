# frozen_string_literal: true

require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Account::UsersController, type: :controller do
  describe "PATCH #update_password" do
    context "with valid params" do
      it "updates the password" do
        request.env["devise.mapping"] = Devise.mappings[:user]
        user = create(:user)
        current_password = user.password
        new_password = "#{current_password}**"
        user.confirm
        sign_in user

        old_password = subject.current_user.encrypted_password # rubocop:disable RSpec/NamedSubject

        hsh = {
          current_password: current_password,
          password: new_password,
          password_confirmation: new_password
        }

        post :update_password, params: {user: hsh}

        expect(subject.current_user.encrypted_password).not_to eq(old_password) # rubocop:disable RSpec/NamedSubject
      end

      it "redirects to the account page" do
        request.env["devise.mapping"] = Devise.mappings[:user]
        user = create(:user)
        current_password = user.password
        new_password = "#{current_password}**"
        user.confirm
        sign_in user

        hsh = {
          current_password: current_password,
          password: new_password,
          password_confirmation: new_password
        }

        post :update_password, params: {user: hsh}

        expect(response).to redirect_to(account_user_url)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'show' template)" do
        request.env["devise.mapping"] = Devise.mappings[:user]
        user = create(:user)
        user.confirm
        sign_in user

        hsh = {
          current_password: "blabla",
          password: "blabla",
          password_confirmation: "blabla"
        }

        post :update_password, params: {user: hsh}

        expect(response).to be_successful
      end
    end
  end

  describe "PATCH #update_email" do
    login_user

    context "with valid params" do
      it "updates the email" do
        old_email = subject.current_user.email # rubocop:disable RSpec/NamedSubject
        new_email = "pipo@molo.fr"

        hsh = {
          email: new_email
        }

        post :update_email, params: {user: hsh}

        expect(subject.current_user.email).to eq(old_email) # rubocop:disable RSpec/NamedSubject
        expect(subject.current_user.unconfirmed_email).to eq(new_email) # rubocop:disable RSpec/NamedSubject
      end

      it "redirects to the account page" do
        new_email = "pipo@molo.fr"

        hsh = {
          email: new_email
        }

        post :update_email, params: {user: hsh}

        expect(response).to redirect_to(account_user_url)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'show' template)" do
        hsh = {
          email: "pipo"
        }

        post :update_email, params: {user: hsh}

        expect(response).to be_successful
      end
    end
  end

  describe "PATCH #unlink_france_connect" do
    login_user

    context "with omniauth_informations" do
      before do
        create(:omniauth_information, user: subject.current_user) # rubocop:disable RSpec/NamedSubject
      end

      it "destroy omniauth_informations" do
        patch :unlink_france_connect

        expect(subject.current_user.omniauth_informations.count).to eq(0) # rubocop:disable RSpec/NamedSubject
      end

      it "redirects to the account page" do
        patch :unlink_france_connect

        expect(response).to redirect_to(account_user_url)
      end
    end

    context "without omniauth_informations" do
      it "returns a success response (i.e. to display the 'show' template)" do
        patch :unlink_france_connect

        expect(response).to redirect_to(account_user_url)
      end
    end
  end
end
