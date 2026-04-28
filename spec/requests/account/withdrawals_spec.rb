# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account::Withdrawals" do
  describe "POST /mon-compte/candidatures/:job_application_id/desistement" do
    let(:user) { create(:confirmed_user) }

    before { sign_in user }

    context "when job application is rejected" do
      subject(:withdrawal_request) { post account_job_application_withdrawal_path(rejected_application) }

      let(:rejected_application) { create(:job_application, :rejected, user: user) }

      it "does not change job application state" do
        expect { withdrawal_request }.not_to change { rejected_application.reload.rejected }
      end

      it "returns an error message" do
        withdrawal_request
        expect(flash[:notice]).to eq(I18n.t("account.withdrawals.create.failure"))
      end

      it "redirects to job application page" do
        withdrawal_request
        expect(response).to redirect_to(account_job_application_path(rejected_application))
      end
    end

    context "when job application is affected" do
      subject(:withdrawal_request) { post account_job_application_withdrawal_path(affected_application) }

      let(:affected_application) { create(:job_application, state: :affected, user: user) }

      it "does not change job application state" do
        expect { withdrawal_request }.not_to change { affected_application.reload.state }
      end

      it "returns an error message" do
        withdrawal_request
        expect(flash[:notice]).to eq(I18n.t("account.withdrawals.create.failure"))
      end

      it "redirects to job application page" do
        withdrawal_request
        expect(response).to redirect_to(account_job_application_path(affected_application))
      end
    end

    context "when the job application is not rejected or affected" do
      subject(:withdrawal_request) { post account_job_application_withdrawal_path(job_application) }

      let!(:rejection_reason) { create(:rejection_reason, name: RejectionReason::WITHDRAWAL_REASON) }
      let(:job_application) { create(:job_application, user: user) }

      it "updates the job_application state to rejected" do
        expect { withdrawal_request }.to change { job_application.reload.rejected }.from(false).to(true)
      end

      it "adds the right rejection_reason_id" do
        withdrawal_request
        expect(job_application.reload.rejection_reason).to eq(rejection_reason)
      end

      it "displays a success message" do
        withdrawal_request
        expect(flash[:notice]).to eq(I18n.t("account.withdrawals.create.success"))
      end

      it "redirects to job application page" do
        withdrawal_request
        expect(response).to redirect_to(account_job_application_path(job_application))
      end

      it "enqueues a notify_withdrawn email" do
        expect { withdrawal_request }.to have_enqueued_mail(ApplicantNotificationsMailer, :notify_withdrawn)
      end

      it "does not enqueue a notify_rejected email" do
        expect { withdrawal_request }.not_to have_enqueued_mail(ApplicantNotificationsMailer, :notify_rejected)
      end
    end
  end
end
