# frozen_string_literal: true

require "rails_helper"

RSpec.describe ZipFile, type: :model do
  it "is valid without the zip" do
    expect(build(:zip_file, zip: nil)).to be_valid
  end

  it "plans it's own destruction" do
    expect {
      create(:zip_file)
    }.to have_enqueued_job(DestroyZipFileJob)
  end
end

# == Schema Information
#
# Table name: zip_files
#
#  id         :uuid             not null, primary key
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
