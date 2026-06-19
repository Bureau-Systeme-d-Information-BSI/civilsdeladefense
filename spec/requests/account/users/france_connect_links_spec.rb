# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Users::FranceConnectLinks" do
  subject(:destroy_request) { delete account_user_france_connect_link_path }

  let(:user) { create(:confirmed_user) }

  before do
    create(:omniauth_information, user:)
    sign_in user
    destroy_request
  end

  it { expect(response).to redirect_to(account_user_path) }

  it { expect(user.omniauth_informations.count).to eq(0) }
end
