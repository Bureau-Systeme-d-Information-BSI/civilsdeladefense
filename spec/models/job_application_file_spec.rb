require "rails_helper"

RSpec.describe JobApplicationFile do
  describe "delegations" do
    it { is_expected.to delegate_method(:state).to(:job_application).with_prefix(true) }
  end

  describe "#downloadable?" do
    subject(:downloadable) { job_application_file.downloadable? }

    let(:job_application_file) { build(:job_application_file, job_application:, job_application_file_type:) }
    let(:job_application) { build(:job_application, state: current_state) }
    let(:job_application_file_type) { build(:job_application_file_type, required_to_state: max_downloadable_state) }

    context "when the current state is before the max downloadable state" do
      let(:current_state) { :initial }
      let(:max_downloadable_state) { :phone_meeting }

      it { is_expected.to be(true) }
    end

    context "when the current state is afterr the max downloadable state" do
      let(:current_state) { :phone_meeting }
      let(:max_downloadable_state) { :phone_meeting }

      it { is_expected.to be(false) }
    end
  end
end
