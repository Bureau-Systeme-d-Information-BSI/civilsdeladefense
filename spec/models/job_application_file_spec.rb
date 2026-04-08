require "rails_helper"

RSpec.describe JobApplicationFile do
  describe "delegations" do
    it { is_expected.to delegate_method(:state).to(:job_application).with_prefix(true) }
  end

  describe "#record_by_user" do
    subject(:record_by_user) { job_application_file.record_by_user }

    let(:job_application_file) { build(:job_application_file, job_application:) }
    let(:job_application) { create(:job_application) }

    context "when the file is valid" do
      it { is_expected.to be(true) }

      it { expect { record_by_user }.to change { job_application.job_application_files.count }.by(1) }
    end

    context "when the file is invalid" do
      before { job_application_file.content = nil }

      it { is_expected.to be(false) }

      it { expect { record_by_user }.not_to change { job_application.job_application_files.count } }
    end
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
