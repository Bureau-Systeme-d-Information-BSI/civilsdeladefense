# frozen_string_literal: true

require "rails_helper"

RSpec.describe LogoUploader do
  describe "#fog_public" do
    subject(:fog_public) { described_class.new.fog_public }

    it { is_expected.to be(true) }
  end

  describe "#content_type_allowlist" do
    subject(:content_type_allowlist) { described_class.new.content_type_allowlist }

    it { is_expected.to eq(%r{image/}) }
  end
end
