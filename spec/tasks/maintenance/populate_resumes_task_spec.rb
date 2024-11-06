# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateResumesTask do
    describe "#process" do
      subject(:process) { described_class.process(profile) }
      let(:profile) { create(:profile) }

      before { profile.profileable.job_applications << create(:job_application, :with_job_application_file) }

      it { expect { process }.to change { profile.reload.resume.present? }.from(false).to(true) }
    end
  end
end
