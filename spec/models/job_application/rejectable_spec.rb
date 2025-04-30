require "rails_helper"

RSpec.describe JobApplication::Rejectable do
  describe "associations" do
    subject { build(:job_application) }

    it { is_expected.to belong_to(:rejection_reason).optional }
  end

  describe "validations" do
    describe "#rejection_reason" do
      subject { job_application.valid? }

      let(:job_application) { build(:job_application, :with_employer) }

      context "when the job application is rejected" do
        before { job_application.rejected = true }

        it { is_expected.to be false }
      end

      context "when the job application is a rejected and has a rejection reason" do
        before do
          job_application.rejected = true
          job_application.rejection_reason = create(:rejection_reason)
        end

        it { is_expected.to be true }
      end

      context "when the job application is not rejected" do
        before { job_application.rejected = false }

        it { is_expected.to be true }
      end
    end
  end

  describe "before_validation callbacks" do
    describe "#cleanup_rejection_reason" do
      subject(:unreject) { job_application.update!(rejected: false) }

      let(:job_application) { create(:job_application, rejected: true, rejection_reason: create(:rejection_reason)) }

      it { expect { unreject }.to change(job_application, :rejection_reason).to(nil) }
    end
  end

  describe "#reject!" do
    subject(:reject) { job_application.reject!(rejection_reason:) }

    let(:rejection_reason) { create(:rejection_reason) }
    let(:job_application) { create(:job_application) }

    it { expect { reject }.to change(job_application, :rejected).to(true) }

    it { expect { reject }.to change(job_application, :rejection_reason).to(rejection_reason) }
  end
end
