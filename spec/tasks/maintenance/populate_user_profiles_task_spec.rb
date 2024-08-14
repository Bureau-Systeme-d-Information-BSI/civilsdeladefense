# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe PopulateUserProfilesTask do
    describe "#process" do
      subject(:process) { described_class.process(user) }
      let(:user) { create(:user) }

      before do
        create(:job_application, user:)
        user.update!(profile: nil)
      end

      it { expect { process }.to change { user.reload.profile }.from(nil).to(an_instance_of(Profile)) }
    end
  end
end
