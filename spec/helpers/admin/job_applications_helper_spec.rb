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

  describe "#change_state_options" do
    subject(:change_state_options) { helper.change_state_options(job_application, administrator) }

    let(:job_application) { build(:job_application, state:) }
    let(:administrator) { build(:administrator, roles:) }

    context "when the administrator can transition to several states" do
      let(:roles) { [:functional_administrator] }
      let(:state) { :initial }

      it "includes the current state and every allowed target state" do
        expect(change_state_options.map(&:last)).to contain_exactly(:initial, :phone_meeting, :to_be_met, :financial_estimate)
      end

      it "translates each option label" do
        expect(change_state_options.map(&:first)).to all(be_a(String).and(be_present))
      end
    end

    context "when the administrator has no allowed transition from the current state" do
      let(:roles) { [:hr_manager] }
      let(:state) { :initial }

      it "returns only the current state" do
        expect(change_state_options.map(&:last)).to contain_exactly(:initial)
      end
    end
  end

  describe "#can_change_state?" do
    subject(:can_change_state?) { helper.can_change_state?(job_application, administrator) }

    let(:job_application) { build(:job_application, state: state) }
    let(:administrator) { build(:administrator, roles: roles) }

    context "when the administrator has at least one allowed transition" do
      let(:roles) { [:functional_administrator] }
      let(:state) { :initial }

      it { is_expected.to be(true) }
    end

    context "when the administrator has no allowed transition from the current state" do
      let(:roles) { [:hr_manager] }
      let(:state) { :initial }

      it { is_expected.to be(false) }
    end
  end
end
