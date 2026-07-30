# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Accounts::Photos" do
  let(:administrator) { create(:administrator, :with_photo) }

  before do
    sign_in administrator
    photo_request
  end

  describe "GET /admin/account/photo" do
    subject(:photo_request) { get admin_account_photo_path(id: administrator.id) }

    it { expect(response).to be_successful }

    it { expect(response.headers["Content-Type"]).to eq("image/jpeg") }
  end
end
