require "rails_helper"

RSpec.describe JobApplicationFile do
  describe "delegations" do
    it { is_expected.to delegate_method(:state).to(:job_application).with_prefix(true) }
  end

  describe "#downloadable?" do
    subject(:downloadable) { job_application_file.downloadable? }

    let(:job_application_file) { build(:job_application_file, job_application:, job_application_file_type:) }
    let(:job_application) { build(:job_application, state: current_state) }
    let(:job_application_file_type) { create(:job_application_file_type) }

    context "when the current state is before the max administrator visibility rule" do
      let(:current_state) { :initial }

      before { job_application_file_type.visibility_rules.create!(by: :administrator, state: :phone_meeting) }

      it { is_expected.to be(true) }
    end

    context "when the current state equals the max administrator visibility rule" do
      let(:current_state) { :initial }

      it { is_expected.to be(false) }
    end

    context "when the current state is after the max administrator visibility rule" do
      let(:current_state) { :phone_meeting }

      it { is_expected.to be(false) }
    end
  end
end
