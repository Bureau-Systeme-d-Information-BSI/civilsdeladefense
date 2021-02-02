# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:sub) { SecureRandom.uuid }
  let(:email) { Faker::Internet.safe_email }
  let(:family_name) { Faker::Name.last_name }
  let(:given_name) { Faker::Name.first_name }

  let(:client) { instance_double(FranceConnectClient) }

  describe 'POST #france_connect' do
    before do
      allow(FranceConnectClient).to receive(:new).and_return(client)
      allow(client).to receive(:user_info).and_return(
        sub: sub,
        email: email,
        family_name: family_name,
        given_name: given_name
      )
    end

    context 'when user connect for the first time' do
      let(:user) { User.find_by(email: email) }

      before do
        post :france_connect, params: { code: :code }
      end

      it 'returns a success response' do
        expect(response).to redirect_to(account_job_applications_path)
      end

      it 'create a user with same email' do
        expect(user).to be_present
      end

      it 'sign_in user' do
        expect(controller.current_user).to eq(user)
      end

      it 'create a france_connect_information with sub' do
        expect(FranceConnectInformation.find_by(sub: sub)).to be_present
      end
    end

    context 'when user has already used FranceConnect' do
      let(:fci) do
        FactoryBot.create(
          :france_connect_information,
          sub: sub, email: email, family_name: family_name, given_name: given_name
        )
      end
      let!(:user) { fci.user }

      before do
        post :france_connect, params: { code: :code }
      end

      it 'returns a success response' do
        expect(response).to redirect_to(account_job_applications_path)
      end

      it 'sign_in user' do
        expect(controller.current_user).to eq(user)
      end
    end

    context 'when user has already login via email' do
      let!(:user) { FactoryBot.create(:confirmed_user, email: email) }

      before do
        post :france_connect, params: { code: :code }
      end

      it 'returns a success response' do
        expect(response).to redirect_to(account_job_applications_path)
      end

      it 'sign_in user' do
        expect(controller.current_user).to eq(user)
      end
    end
  end
end
