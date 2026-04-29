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

    describe "#immutable_state" do
      subject { job_application.valid? }

      let(:job_application) { build(:job_application, :with_employer) }

      before { job_application.state = :accepted }

      context "when the job application is rejected" do
        before { job_application.rejected = true }

        it { is_expected.to be false }
      end

      context "when the job application is not rejected" do
        before { job_application.rejected = false }

        it { is_expected.to be true }
      end
    end
  end

  describe "scopes" do
    describe ".rejecteds" do
      subject { JobApplication.rejecteds }

      let!(:matching_job_application) do
        create(:job_application, rejected: true, rejection_reason: create(:rejection_reason))
      end
      let!(:non_matching_job_application) { create(:job_application, rejected: false) }

      it { is_expected.to include(matching_job_application) }

      it { is_expected.not_to include(non_matching_job_application) }
    end

    describe ".not_rejecteds" do
      subject { JobApplication.not_rejecteds }

      let!(:matching_job_application) { create(:job_application, rejected: false) }
      let!(:non_matching_job_application) do
        create(:job_application, rejected: true, rejection_reason: create(:rejection_reason))
      end

      it { is_expected.to include(matching_job_application) }

      it { is_expected.not_to include(non_matching_job_application) }
    end
  end

  describe "before_validation callbacks" do
    describe "#cleanup_rejection_reason" do
      subject(:unreject) { job_application.update!(rejected: false) }

      let(:job_application) { create(:job_application, rejected: true, rejection_reason: create(:rejection_reason)) }

      it { expect { unreject }.to change(job_application, :rejection_reason).to(nil) }
    end
  end

  describe "#unreject!" do
    subject(:unreject) { job_application.unreject! }

    let(:job_application) { create(:job_application, state: :to_be_met, rejected: true, rejection_reason: create(:rejection_reason)) }

    it { expect { unreject }.to change(job_application, :rejected).to(false) }

    it { expect { unreject }.to change(job_application, :rejection_reason).to(nil) }

    it { expect { unreject }.to change(job_application, :state).to("initial") }
  end

  describe "#reject!" do
    let(:rejection_reason) { create(:rejection_reason) }
    let(:job_application) { create(:job_application) }

    it "updates job application to rejected" do
      expect { job_application.reject!(rejection_reason:) }.to change(job_application, :rejected).to(true)
    end

    it "adds a rejection reason to job application" do
      job_application.reject!(rejection_reason:)
      expect(job_application.rejection_reason).to eq(rejection_reason)
    end

    context "when rejection is from user (withdrawal)" do
      let(:rejection_reason) { create(:rejection_reason, name: RejectionReason::WITHDRAWAL_REASON) }

      subject(:reject) { job_application.reject!(rejection_reason:, from_user: true) }

      it "enqueues the notify_withdraw mailer" do
        expect { reject }.to have_enqueued_mail(ApplicantNotificationsMailer, :notify_withdrawn)
      end

      it "does not enqueue notify_reject mailer" do
        expect { reject }.not_to have_enqueued_mail(ApplicantNotificationsMailer, :notify_rejected)
      end

      context "when rejection_reason is not the withdrawal reason" do
        let(:rejection_reason) { create(:rejection_reason) }

        it "raises an ArgumentError" do
          expect { reject }.to raise_error(ArgumentError)
        end
      end
    end

    context "when rejection is not from user (employer rejection)" do
      subject(:reject) { job_application.reject!(rejection_reason:) }

      it "enqueues the notify_reject mailer" do
        expect { reject }.to have_enqueued_mail(ApplicantNotificationsMailer, :notify_rejected)
      end

      it "does not enqueue notify_withdrawn mailer" do
        expect { reject }.not_to have_enqueued_mail(ApplicantNotificationsMailer, :notify_withdrawn)
      end
    end
  end
end
