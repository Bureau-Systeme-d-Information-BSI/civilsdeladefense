# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplicationFile::Securable, type: :model do
  describe "#document_content" do
    subject(:document_content) { job_application_file.document_content }

    context "when the secured_content exists" do
      let(:job_application_file) { build(:job_application_file, :secured) }

      it { is_expected.to eq(job_application_file.secured_content) }
    end

    context "when the secured content doesn't exist" do
      context "when the content exists" do
        let(:job_application_file) { build(:job_application_file) }

        it { is_expected.to eq(job_application_file.content) }
      end

      context "when the content doesn't exist" do
        let(:job_application_file) { build(:job_application_file, content: nil) }

        it { is_expected.to be_nil }
      end
    end
  end

  describe "#secured?" do
    subject(:secured?) { job_application_file.secured? }

    context "when the job application file is secured" do
      let(:job_application_file) { build(:job_application_file, :secured) }

      it { is_expected.to be(true) }
    end

    context "when the job application file is not secured" do
      let(:job_application_file) { build(:job_application_file) }

      it { is_expected.to be(false) }
    end
  end

  describe "After commit" do
    subject(:commit) { job_application_file.save }

    context "when the job application file is secured" do
      let(:job_application_file) { build(:job_application_file, :secured) }

      it { expect { commit }.not_to have_enqueued_job { SecureContentJob } }
    end

    context "when the job application file is not secured" do
      let!(:job_application_file) { build(:job_application_file) }

      it { expect { commit }.to have_enqueued_job { SecureContentJob }.with(job_application_file.id) }
    end
  end
end
