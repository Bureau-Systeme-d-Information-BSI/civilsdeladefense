# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommonUploader do
  describe "#paperclip_path" do
    subject(:paperclip_path) { described_class.new.paperclip_path }

    context "when the storage is the local filesystem" do
      before { allow(described_class).to receive(:storage).and_return("CarrierWave::Storage::File".safe_constantize) }

      it { is_expected.to eq(":rails_root/public/system/:class/:attachment/:id_partition/:style/:basename.:extension") }
    end

    context "when the storage is Fog" do
      before { allow(described_class).to receive(:storage).and_return("CarrierWave::Storage::Fog".safe_constantize) }

      it { is_expected.to eq(":class/:attachment/:id_partition/:style/:basename.:extension") }
    end
  end
end
