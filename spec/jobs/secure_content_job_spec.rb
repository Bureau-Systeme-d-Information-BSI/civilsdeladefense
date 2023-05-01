# frozen_string_literal: true

require "rails_helper"

RSpec.describe SecureContentJob, type: :job do
  subject(:perform) { described_class.new.perform(id: job_application_file.id) }

  context "when the job application file is not found" do
    let(:job_application_file) { instance_double(JobApplicationFile, id: -1) }

    it "does nothing" do
      expect_any_instance_of(JobApplicationFile).not_to receive(:secure_content!)
      perform
    end
  end

  context "when the job application file is found" do
    let(:job_application_file) { create(:job_application_file) }

    it "secures the job application file's content" do
      expect_any_instance_of(JobApplicationFile).to receive(:secure_content!)
      perform
    end
  end
end
