# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Users::Photos" do
  subject(:show_request) { get account_user_photo_path }

  let(:user) { create(:confirmed_user, :with_photo) }

  before do
    sign_in user
    show_request
  end

  it { expect(response).to be_successful }

  it { expect(response.headers["Content-Type"]).to eq("image/jpeg") }
end
