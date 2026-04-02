require "rails_helper"

RSpec.describe JobApplication::Notifiable do
  describe "after_update callbacks" do
    describe "#notify_hr_managers_contract_drafting" do
      subject(:contract_drafting) { job_application.contract_drafting! }

      let(:job_application) { create(:job_application, state: :accepted) }

      context "when the job application has at least one hr_manager" do
        let(:administrator) { create(:administrator, roles: [:hr_manager]) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          create(:job_offer_actor, job_offer: job_application.job_offer, administrator:, role: :employer)
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            contract_drafting: mailer_double
          )
          contract_drafting
        end

        it { expect(NotificationsMailer).to have_received(:with).with(administrator:, job_application:) }

        it { expect(NotificationsMailer).to have_received(:contract_drafting) }
      end

      context "when the job application doesn't have any hr managers" do
        let(:administrator) { create(:administrator, roles: [:hr_manager]) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            contract_drafting: mailer_double
          )
          contract_drafting
        end

        it { expect(NotificationsMailer).not_to have_received(:with) }
      end
    end

    describe "#notify_hr_managers_contract_feedback_waiting" do
      subject(:contract_feedback_waiting) { job_application.contract_feedback_waiting! }

      let(:job_application) { create(:job_application, state: :contract_drafting) }

      context "when the job application has at least one hr_manager" do
        let(:administrator) { create(:administrator, roles: [:hr_manager]) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          create(:job_offer_actor, job_offer: job_application.job_offer, administrator:, role: :employer)
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            contract_feedback_waiting: mailer_double
          )
          contract_feedback_waiting
        end

        it { expect(NotificationsMailer).to have_received(:with).with(administrator:, job_application:) }

        it { expect(NotificationsMailer).to have_received(:contract_feedback_waiting) }
      end

      context "when the job application doesn't have any hr managers" do
        let(:administrator) { create(:administrator, roles: [:hr_manager]) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            contract_feedback_waiting: mailer_double
          )
          contract_feedback_waiting
        end

        it { expect(NotificationsMailer).not_to have_received(:with) }
      end
    end

    describe "#notify_payroll_managers_contract_received" do
      subject(:contract_received) { job_application.contract_received! }

      let(:job_application) { create(:job_application, state: :contract_feedback_waiting) }

      context "when the job application has at least one payroll_manager" do
        let(:administrator) { create(:administrator, roles: [:payroll_manager]) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          create(:job_offer_actor, job_offer: job_application.job_offer, administrator:, role: :employer)
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            contract_received: mailer_double
          )
          contract_received
        end

        it { expect(NotificationsMailer).to have_received(:with).with(administrator:, job_application:) }

        it { expect(NotificationsMailer).to have_received(:contract_received) }
      end

      context "when the job application doesn't have any payroll managers" do
        let(:administrator) { create(:administrator, roles: [:payroll_manager]) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            contract_received: mailer_double
          )
          contract_received
        end

        it { expect(NotificationsMailer).not_to have_received(:with) }
      end
    end

    describe "#notify_managers_affected" do
      subject(:affected) { job_application.affected! }

      let(:job_application) { create(:job_application, state: :contract_received) }

      context "when the job application has hr_managers and payroll_managers" do
        let(:hr_manager) { create(:administrator, roles: [:hr_manager]) }
        let(:payroll_manager) { create(:administrator, roles: [:payroll_manager]) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          create(:job_offer_actor, job_offer: job_application.job_offer, administrator: hr_manager, role: :employer)
          create(:job_offer_actor, job_offer: job_application.job_offer, administrator: payroll_manager, role: :employer)
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            affected: mailer_double
          )
          affected
        end

        it { expect(NotificationsMailer).to have_received(:with).with(administrator: hr_manager, job_application:) }

        it { expect(NotificationsMailer).to have_received(:with).with(administrator: payroll_manager, job_application:) }

        it { expect(NotificationsMailer).to have_received(:affected).twice }
      end

      context "when the job application has only hr_managers" do
        let(:hr_manager) { create(:administrator, roles: [:hr_manager]) }
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          create(:job_offer_actor, job_offer: job_application.job_offer, administrator: hr_manager, role: :employer)
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            affected: mailer_double
          )
          affected
        end

        it { expect(NotificationsMailer).to have_received(:with).with(administrator: hr_manager, job_application:) }

        it { expect(NotificationsMailer).to have_received(:affected).once }
      end

      context "when the job application doesn't have any managers" do
        let(:mailer_double) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          allow(NotificationsMailer).to receive_messages(
            with: NotificationsMailer,
            affected: mailer_double
          )
          affected
        end

        it { expect(NotificationsMailer).not_to have_received(:with) }
      end
    end
  end
end
