# frozen_string_literal: true

require "rails_helper"

RSpec.describe DestroyZipFileJob do
  it "destroys the zip file" do
    zip_file = create(:zip_file)
    expect {
      described_class.new.perform(id: zip_file.id)
    }.to change(ZipFile, :count).by(-1)
  end

  describe "edge cases" do
    it "doesn't crash when the zip file is missing" do
      expect {
        described_class.new.perform(id: -1)
      }.not_to raise_error
    end
  end
end
