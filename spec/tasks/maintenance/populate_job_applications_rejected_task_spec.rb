# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateJobApplicationsRejectedTask do
    describe "#collection" do
      subject(:collection) { described_class.collection }
      let!(:rejected_job_application) { create(:job_application, state: 1) } # rejected
      let!(:phone_meeting_rejected_job_application) { create(:job_application, state: 3) } # phone_meeting_rejected
      let!(:after_meeting_rejected_job_application) { create(:job_application, state: 6) } # after_meeting_rejected
      let!(:other_job_application) { create(:job_application) }
      let!(:already_migrated_job_application) do
        create(:job_application, state: 1, rejected: true, rejection_reason: create(:rejection_reason))
      end

      it { is_expected.to include(rejected_job_application) }

      it { is_expected.to include(phone_meeting_rejected_job_application) }

      it { is_expected.to include(after_meeting_rejected_job_application) }

      it { is_expected.not_to include(other_job_application) }

      it { is_expected.not_to include(already_migrated_job_application) }
    end

    describe "#process" do
      subject(:process) { described_class.process(job_application) }
      let(:job_application) { create(:job_application, rejected: false) }

      it { expect { process }.to change(job_application, :rejected).from(false).to(true) }
    end
  end
end
