# frozen_string_literal: false

require "rails_helper"

RSpec.describe JobApplication do
  let(:job_offer) { create(:job_offer) }
  let(:job_application) { create(:job_application, job_offer:) }

  describe "delegations" do
    it { is_expected.to delegate_method(:employer_recruiters).to(:job_offer).with_prefix(true) }

    it { is_expected.to delegate_method(:hr_managers).to(:job_offer).with_prefix(true) }
  end

  describe "validations" do
    describe "#cant_be_accepted_twice" do
      subject(:acceptance) { job_application.accepted! }

      let(:job_application) { create(:job_application, state: :financial_estimate) }

      context "when the user has not been accepted for another job offer" do
        it { is_expected.to be(true) }
      end

      context "when the user has been accepted for another job offer" do
        before { create(:job_application, user: job_application.user, job_offer: create(:job_offer), state: :accepted) }

        it { expect { acceptance }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end

    describe "#cant_accept_remaining_initial_job_applications" do
      subject(:acceptance) { job_application.accepted! }

      let(:job_application) { create(:job_application, job_offer:, state: :financial_estimate) }

      context "when the job offer has no initial job applications" do
        it { is_expected.to be(true) }
      end

      context "when the job offer has initial job applications" do
        before { create(:job_application, job_offer:, state: :initial) }

        it { expect { acceptance }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end

    describe "#cant_skip_state" do
      subject(:state_change) { job_application.update!(state:) }

      let(:job_application) { create(:job_application, state: :phone_meeting) }

      context "when the state is immediatly after the previous state" do
        let(:state) { "to_be_met" }

        it { is_expected.to be(true) }
      end

      context "when the state is before the previous state" do
        let(:state) { "initial" }

        it { is_expected.to be(true) }
      end

      context "when the state is after the previous state" do
        let(:state) { "accepted" }

        it { expect { state_change }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end

  describe "scopes" do
    describe ".with_category" do
      subject { described_class.with_category }

      let(:matching) { create(:job_application, category: create(:category)) }
      let(:unmatching) { create(:job_application, category: nil) }

      it { is_expected.to include(matching) }

      it { is_expected.not_to include(unmatching) }
    end
  end

  describe "files_to_be_provided" do
    before do
      create(:job_application_file_type, name: "CV", from_state: :initial, kind: :applicant_provided)
      create(:job_application_file_type, name: "LM", from_state: :initial, kind: :applicant_provided)
      create(:job_application_file_type, name: "FILE", from_state: :to_be_met, kind: :applicant_provided)
    end

    let(:job_application) { create(:job_application, job_offer:, state: :phone_meeting) }

    it "computes files to be provided" do
      result = job_application.files_to_be_provided
      must_be_provided_files = result[:must_be_provided_files]
      optional_file_types = result[:optional_file_types]

      expect(must_be_provided_files.size).to eq(2)
      expect(optional_file_types.size).to eq(1)

      job_application.job_application_files.each do |file|
        file.content = fixture_file_upload("document.pdf", "application/pdf")
      end
      job_application.to_be_met!

      result = job_application.files_to_be_provided
      must_be_provided_files = result[:must_be_provided_files]
      optional_file_types = result[:optional_file_types]

      expect(must_be_provided_files.size).to eq(3)
      expect(optional_file_types.size).to eq(0)
    end
  end

  describe "cant_accept_before_delay" do
    subject(:acceptance) { job_application.accepted! }

    let(:job_application) { create(:job_application, job_offer:, state: :financial_estimate) }

    context "when job_offer published 20 days before" do
      before { job_offer.update(csp_date: 20.days.before) }

      it "cant be accepted" do
        expect { acceptance }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when job_offer published 31 days before" do
      before { job_offer.update(csp_date: 31.days.before) }

      it { is_expected.to be(true) }
    end
  end

  describe "complete_files_before_draft_contract" do
    let(:job_application) { create(:job_application, state: :accepted) }
    let!(:jaft_1) do
      create(:job_application_file_type, name: "File 1", from_state: :accepted, kind: :applicant_provided)
    end
    let!(:jaft_2) do
      create(:job_application_file_type, name: "File 2", from_state: :to_be_met, kind: :applicant_provided)
    end

    context "when no files are filled" do
      it "cant pass to contract_drafting" do
        expect { job_application.contract_drafting! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when files are fill but not validated" do
      before do
        create(:job_application_file, job_application: job_application, job_application_file_type: jaft_1)
        create(:job_application_file, job_application: job_application, job_application_file_type: jaft_2)
      end

      it "cant pass to contract_drafting" do
        expect { job_application.contract_drafting! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when files are fill and validated" do
      before do
        create(
          :job_application_file,
          job_application: job_application, job_application_file_type: jaft_1, is_validated: true
        )
        create(
          :job_application_file,
          job_application: job_application, job_application_file_type: jaft_2, is_validated: true
        )
      end

      it "can pass to contract_drafting" do
        expect(job_application.contract_drafting!).to be(true)
      end
    end

    describe "required_files_are_validated" do
      subject(:chante_state) { job_application.to_be_met! }

      let!(:job_application) { create(:job_application, state: :phone_meeting) }
      let!(:job_application_file_type) do
        create(:job_application_file_type, required: true, required_from_state: :phone_meeting, required_to_state: :accepted)
      end

      context "when required files are present and validated" do
        before { create(:job_application_file, job_application:, job_application_file_type:).check! }

        it { is_expected.to be(true) }
      end

      context "when required files are present but not validated" do
        before { create(:job_application_file, job_application:, job_application_file_type:).uncheck! }

        it { expect { chante_state }.to raise_error(ActiveRecord::RecordInvalid) }
      end

      context "when required files are missing" do
        it { expect { chante_state }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end

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
  end
end

# == Schema Information
#
# Table name: job_applications
#
#  id                                :uuid             not null, primary key
#  administrator_notifications_count :integer          default(0)
#  emails_administrator_unread_count :integer          default(0)
#  emails_count                      :integer          default(0)
#  emails_unread_count               :integer          default(0)
#  emails_user_unread_count          :integer          default(0)
#  experiences_fit_job_offer         :boolean
#  files_count                       :integer          default(0)
#  files_unread_count                :integer          default(0)
#  preselection                      :integer          default(0)
#  rejected                          :boolean          default(FALSE)
#  skills_fit_job_offer              :boolean
#  state                             :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  category_id                       :uuid
#  employer_id                       :uuid
#  job_offer_id                      :uuid
#  organization_id                   :uuid
#  rejection_reason_id               :uuid
#  user_id                           :uuid
#
# Indexes
#
#  index_job_applications_on_category_id          (category_id)
#  index_job_applications_on_employer_id          (employer_id)
#  index_job_applications_on_job_offer_id         (job_offer_id)
#  index_job_applications_on_organization_id      (organization_id)
#  index_job_applications_on_rejection_reason_id  (rejection_reason_id)
#  index_job_applications_on_state                (state)
#  index_job_applications_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_0e9ee51b69  (user_id => users.id)
#  fk_rails_36c9b0d626  (category_id => categories.id)
#  fk_rails_88b000fe87  (job_offer_id => job_offers.id)
#  fk_rails_e668fb8ac4  (employer_id => employers.id)
#  fk_rails_e73e1d195a  (rejection_reason_id => rejection_reasons.id)
#
