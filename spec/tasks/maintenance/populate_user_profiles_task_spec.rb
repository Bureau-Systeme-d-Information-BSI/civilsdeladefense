# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateUserProfilesTask do
    describe "#process" do
      subject(:process) { described_class.process(user) }

      before { user.profile.destroy! }

      context "when the user has a job application" do
        let(:job_application) { create(:job_application) }
        let(:user) { job_application.user }

        context "when the job application has a profile" do
          let!(:profile) { create(:profile, profileable: job_application) }

          it { expect { process }.to change { user.reload.profile }.to(profile) }

          it { expect { process }.to change { profile.reload.profileable }.from(job_application).to(user) }
        end

        context "when the job application does not have a profile" do
          it { expect { process }.to change { user.reload.profile }.from(nil).to(an_instance_of(Profile)) }

          it { expect { process }.to change(Profile, :count).by(1) }
        end
      end

      context "when the user does not have a job application" do
        let(:user) { create(:user) }

        it { expect { process }.to change { user.reload.profile }.from(nil).to(an_instance_of(Profile)) }

        it { expect { process }.to change(Profile, :count).by(1) }
      end
    end
  end
end
