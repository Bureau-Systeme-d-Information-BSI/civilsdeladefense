# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Downloads" do
  describe "GET /downloads/:id" do
    subject(:show_request) { get download_path(resource, resource_type: "User", attribute_name: "photo"), headers: }

    before { show_request }

    let(:resource) { create(:user, :with_photo) }

    context "when the secret key is invalid" do
      let(:headers) { {"X-Download-Secret-Key" => "invalid"} }

      it { expect(response).to be_unauthorized }
    end

    context "when the secret key is valid" do
      let(:headers) { {"X-Download-Secret-Key" => ENV["DOWNLOAD_SECRET_KEY"]} }

      it { expect(response).to be_successful }

      it { expect(response.headers["Content-Type"]).to eq "image/jpeg" }
    end
  end
end
