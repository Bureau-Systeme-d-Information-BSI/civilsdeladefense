# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::JobApplicationsHelper do
  describe "#job_application_resume_url" do
    subject(:resume_url) { helper.job_application_resume_url(job_application) }

    context "when job_application is nil" do
      let(:job_application) { nil }

      it { is_expected.to be_nil }
    end

    context "when job_application has a file with visible_by_user file type" do
      let(:job_application) { create(:job_application) }
      let(:job_application_file_type) { create(:job_application_file_type) }

      before { create(:job_application_file, job_application:, job_application_file_type:) }

      it { is_expected.to be_present }
    end

    context "when job_application has no matching file" do
      let(:job_application) { create(:job_application) }

      it { is_expected.to be_nil }
    end

    context "when job_application has a file but file type is not visible by user at initial state" do
      let(:job_application) { create(:job_application) }
      let(:job_application_file_type) { create(:job_application_file_type, kind: :employer_provided) }

      before { create(:job_application_file, job_application:, job_application_file_type:) }

      it { is_expected.to be_nil }
    end
  end
end
