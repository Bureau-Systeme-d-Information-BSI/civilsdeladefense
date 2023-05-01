# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplicationFile::Securable, type: :model do
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
