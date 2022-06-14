# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::ZipFiles", type: :request do
  before { sign_in create(:administrator) }

  describe "GET /show" do
    let(:zip_file) { create(:zip_file) }

    it "returns success when the zip file is missing" do
      get admin_zip_file_path(-1)

      expect(response).to be_successful
    end

    it "returns success when the zip file is present" do
      get admin_zip_file_path(zip_file)

      expect(response).to be_successful
    end

    context "when called with json" do
      it "returns a nil download url when the zip file is missing" do
        get admin_zip_file_path(-1, format: :json)

        expect(response).to be_successful
        expect(JSON.parse(response.body)["download_url"]).to eq(nil)
      end

      it "returns a valid download url when the zip file is present" do
        get admin_zip_file_path(zip_file, format: :json)

        expect(response).to be_successful
        expect(JSON.parse(response.body)["download_url"]).to eq(zip_file.zip.url)
      end
    end
  end
end
