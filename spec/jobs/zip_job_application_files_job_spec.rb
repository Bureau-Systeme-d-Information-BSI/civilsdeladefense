# frozen_string_literal: true

require "rails_helper"

RSpec.describe ZipJobApplicationFilesJob, type: :job do
  let(:job_application_file) { create(:job_application_file) }
  let(:user) { job_application_file.job_application.user }
  let(:id) { SecureRandom.uuid }

  it "creates a zip file with the given id linked to a temporary file that contains job application files" do
    expect {
      described_class.new.perform(zip_id: id, user_ids: [user.id])
    }.to change(ZipFile, :count).by(1)

    zip_file = ZipFile.find(id)
    expect(zip_file.zip_url).to be_present

    Zip::File.open(zip_file.zip.current_path) do |zipfile|
      zipfile.first do |file|
        expect(file.size).not_to eq(0)
        expect(file.name).to eq([
          job_application_file.job_application.user.full_name,
          job_application_file.job_application_file_type.name
        ].join(" - "))
      end
    end
  end

  describe "edge cases" do
    it "doesn't crash when the file is unreadable" do
      allow_any_instance_of(DocumentUploader).to receive(:read).and_raise(NoMethodError)

      expect {
        described_class.new.perform(zip_id: id, user_ids: [user.id])
      }.not_to raise_error
    end

    it "doesn't crash when the zip file already exists" do
      described_class.new.perform(zip_id: id, user_ids: [user.id])

      expect {
        described_class.new.perform(zip_id: id, user_ids: [user.id])
      }.not_to raise_error
    end
  end
end
