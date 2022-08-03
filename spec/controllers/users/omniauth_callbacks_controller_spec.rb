# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  let(:uid) { SecureRandom.uuid }
  let(:email) { Faker::Internet.safe_email }
  let(:last_name) { Faker::Name.last_name }
  let(:first_name) { Faker::Name.first_name }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :france_connect, france_connect_mock(uid, email, first_name, last_name)
    )

    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:france_connect]
  end

  describe "POST #france_connect" do
    context "when user connect for the first time" do
      let(:user) { User.find_by(email: email) }

      before do
        post :france_connect
      end

      it "returns a success response" do
        expect(response).to redirect_to(account_job_applications_path)
      end

      it "create a user with same email" do
        expect(user).to be_present
      end

      it "sign_in user" do
        expect(controller.current_user).to eq(user)
      end

      it "create a omniauth_information with uid" do
        expect(OmniauthInformation.find_by(uid: uid)).to be_present
      end
    end

    context "when user has already used FranceConnect" do
      let!(:fci) do
        create(
          :omniauth_information,
          uid: uid, email: email, last_name: last_name, first_name: first_name
        )
      end

      before do
        post :france_connect
      end

      it "returns a success response" do
        expect(response).to redirect_to(account_job_applications_path)
      end

      it "sign_in user" do
        expect(controller.current_user).to eq(fci.user)
      end
    end

    context "when user has already login via email" do
      let!(:user) { create(:confirmed_user, email: email) }

      before do
        post :france_connect
      end

      it "returns a success response" do
        expect(response).to redirect_to(account_job_applications_path)
      end

      it "sign_in user" do
        expect(controller.current_user).to eq(user)
      end
    end
  end
end

def france_connect_mock(uid, email, first_name, last_name)
  {
    provider: :france_connect,
    uid: uid,
    info: {
      name: nil,
      email: email,
      nickname: nil,
      first_name: first_name,
      last_name: last_name,
      gender: nil,
      image: nil,
      phone: nil,
      urls: {website: nil}
    },
    credentials: {
      id_token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2ZjcC5pbnRlZzAxLmRldi1mcmFuY2Vjb25uZWN0LmZyIiwic3ViIjoiYjI3YmJmNGE1YTI4MDEwOTkxMzM3MzJiOWMxZWRhNzAxMGUwMzAzMmU2M2I5N2IyYTUwMmQyOWJmYWI0MzI4OHYxIiwiYXVkIjoiYTI1ZTBjOTdkNTYxMDhmMzZiZDc0YzlhYzBjZTJlOGUxYzI2YjE4ZGY3NmI5OWZmM2U4MjBjYjczOGJjNGM4MSIsImV4cCI6MTYxMjM1NDIwMiwiaWF0IjoxNjEyMzU0MTQyLCJub25jZSI6Ijc2YmRmNWVmZDI5ZjcxNjA2ZDhiNmY3NWIyOTliYjQ5IiwiaWRwIjoiRkMiLCJhY3IiOiJlaWRhczEiLCJhbXIiOm51bGx9.IbO71arYBk8zQOZbsrVhlmgAXrKbzEy2y7gzXiL6tUY",
      token: "ccd20f33-f6bd-40c2-a1f0-7b7482d05337",
      refresh_token: nil,
      expires_in: 60,
      scope: nil
    },
    extra: {
      raw_info: {
        given_name: first_name,
        family_name: last_name,
        email: email,
        sub: uid,
        iss: ENV["FRANCE_CONNECT_HOST"],
        aud: "a25e0c97d56108f36bd74c9ac0ce2e8e1c26b18df76b99ff3e820cb738bc4c81",
        exp: 1_612_354_202,
        iat: 1_612_354_142,
        nonce: "76bdf5efd29f71606d8b6f75b299bb49",
        idp: "FC",
        acr: "eidas1",
        amr: nil
      }
    }
  }
end
# rubocop:enable Layout/LineLength, Metrics/MethodLength
