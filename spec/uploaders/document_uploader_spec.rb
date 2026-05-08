# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocumentUploader do
  describe "#size" do
    subject(:uploader) { described_class.new }

    context "when the underlying file is missing" do
      before { allow(uploader).to receive(:read).and_return(nil) } # rubocop:disable RSpec/SubjectStub

      it "returns 0 instead of raising on nil.bytesize" do
        expect(uploader.size).to eq(0)
      end
    end

    context "when the underlying file is readable" do
      before { allow(uploader).to receive(:read).and_return("hello") } # rubocop:disable RSpec/SubjectStub

      it "returns the byte size of the decrypted content" do
        expect(uploader.size).to eq(5)
      end
    end
  end
end
