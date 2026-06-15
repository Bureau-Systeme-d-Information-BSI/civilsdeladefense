# frozen_string_literal: true

require "rails_helper"
require "open-uri"

RSpec.describe DownloadJob do
  subject(:perform) { described_class.new.perform(resource_type:, attribute_name:, id:, file_name:) }

  let(:resource_type) { "EmailAttachment" }
  let(:attribute_name) { "content" }
  let(:id) { email_attachment.id }
  let(:email_attachment) { create(:email_attachment) }
  let(:file_name) { Rails.root.join("tmp/download_job_spec.pdf").to_s }

  context "when the file name is blank" do
    let(:id) { 0 }
    let(:file_name) { "" }

    it { is_expected.to be_nil }
  end

  context "when the file name is present" do
    before do
      allow(URI).to receive(:open).and_return(StringIO.new("downloaded content"))
      perform
    end

    after { File.delete(file_name) if File.exist?(file_name) }

    it { expect(email_attachment.reload.content.read).to eq("downloaded content") }

    it { expect(File.exist?(file_name)).to be(false) }
  end
end
