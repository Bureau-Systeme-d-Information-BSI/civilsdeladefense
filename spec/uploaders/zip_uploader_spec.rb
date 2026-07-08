# frozen_string_literal: true

require "rails_helper"

RSpec.describe ZipUploader do
  describe "#content_type_allowlist" do
    subject(:content_type_allowlist) { described_class.new.content_type_allowlist }

    it { is_expected.to eq(%r{application/zip}) }
  end

  describe "#extension_allowlist" do
    subject(:extension_allowlist) { described_class.new.extension_allowlist }

    it { is_expected.to eq(%w[zip]) }
  end

  describe "#store_dir" do
    subject(:store_dir) { described_class.new.store_dir }

    it { is_expected.to eq("public/zip_files") }
  end
end
