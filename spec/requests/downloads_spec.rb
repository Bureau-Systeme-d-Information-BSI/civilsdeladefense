# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Downloads" do
  describe "GET /downloads/:id" do
    shared_examples "a downloadable resource" do |resource_type, attribute_name, content_type|
      subject(:show_request) { get download_path(resource, resource_type:, attribute_name:), headers: }

      before { show_request }

      context "when the secret key is invalid" do
        let(:headers) { {"X-Download-Secret-Key" => "invalid"} }

        it { expect(response).to be_unauthorized }
      end

      context "when the secret key is valid" do
        let(:headers) { {"X-Download-Secret-Key" => ENV["DOWNLOAD_SECRET_KEY"]} }

        it { expect(response).to be_successful }

        it { expect(response.headers["Content-Type"]).to eq(content_type) }
      end
    end

    it_behaves_like "a downloadable resource", "User", "photo", "image/jpeg" do
      let(:resource) { create(:user, :with_photo) }
    end

    it_behaves_like "a downloadable resource", "Profile", "resume", "application/pdf" do
      let(:resource) { create(:profile, :with_resume) }
    end

    it_behaves_like "a downloadable resource", "JobApplicationFile", "content", "application/pdf" do
      let(:resource) { create(:job_application_file) }
    end

    it_behaves_like "a downloadable resource", "EmailAttachment", "content", "application/pdf" do
      let(:resource) { create(:email_attachment) }
    end

    context "when the resource type is invalid" do
      subject(:show_request) do
        get download_path("anything", resource_type: "Invalid", attribute_name: "photo"),
          headers: {"X-Download-Secret-Key" => ENV["DOWNLOAD_SECRET_KEY"]}
      end

      it { expect { show_request }.to raise_error(UncaughtThrowError) }
    end

    context "when the attribute name is invalid" do
      subject(:show_request) do
        get download_path("anything", resource_type: "User", attribute_name: "invalid"),
          headers: {"X-Download-Secret-Key" => ENV["DOWNLOAD_SECRET_KEY"]}
      end

      it { expect { show_request }.to raise_error(UncaughtThrowError) }
    end
  end
end
