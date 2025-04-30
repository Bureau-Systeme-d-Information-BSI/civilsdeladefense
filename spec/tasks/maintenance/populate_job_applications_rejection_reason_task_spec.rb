# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateJobApplicationsRejectionReasonTask do
    describe "#collection" do
      subject(:collection) { described_class.collection }
      let!(:rejected_job_application) { create(:job_application, state: 1, rejection_reason: nil) }
      let!(:phone_meeting_rejected_job_application) { create(:job_application, state: 3, rejection_reason: nil) }
      let!(:after_meeting_rejected_job_application) { create(:job_application, state: 6, rejection_reason: nil) }
      let!(:other_job_application) { create(:job_application) }
      let!(:already_migrated_job_application) { create(:job_application, state: 1, rejected: true, rejection_reason:) }
      let(:rejection_reason) { create(:rejection_reason, name: "Refus") }

      it { is_expected.to include(rejected_job_application) }

      it { is_expected.to include(phone_meeting_rejected_job_application) }

      it { is_expected.to include(after_meeting_rejected_job_application) }

      it { is_expected.not_to include(other_job_application) }

      it { is_expected.not_to include(already_migrated_job_application) }
    end

    describe "#process" do
      subject(:process) { described_class.process(job_application) }
      let(:job_application) { create(:job_application, state: 1, rejection_reason: nil) }
      let(:rejection_reason) { create(:rejection_reason, name: "Refus") }

      it { expect { process }.to change(job_application, :rejection_reason).from(nil).to(rejection_reason) }
    end
  end
end
