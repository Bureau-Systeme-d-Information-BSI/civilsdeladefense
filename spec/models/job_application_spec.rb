# frozen_string_literal: false

require "rails_helper"

RSpec.describe JobApplication do
  let(:job_offer) { create(:job_offer) }
  let(:job_application) { create(:job_application, job_offer:) }

  describe "validations" do
    describe "#cant_be_accepted_twice" do
      subject(:acceptance) { job_application.accepted! }

      let(:job_application) { create(:job_application) }

      context "when the user has not been accepted for another job offer" do
        it { is_expected.to be(true) }
      end

      context "when the user has been accepted for another job offer" do
        before { create(:job_application, user: job_application.user, job_offer: create(:job_offer), state: :accepted) }

        it { expect { acceptance }.to raise_error(ActiveRecord::RecordInvalid) }
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

  describe "after_update callbacks" do
    describe "#notify_new_state" do
      subject(:state_change) { job_application.update!(state:) }

      described_class::NOTIFICATION_STATES.each do |notification_state|
        context "when the state is a notification state (#{notification_state})" do
          let(:state) { notification_state }

          it { expect { state_change }.to have_enqueued_mail(ApplicantNotificationsMailer, :notify_new_state) }
        end
      end

      context "when the state is not a notification state" do
        let(:state) { "initial" }

        it { expect { state_change }.not_to have_enqueued_mail(ApplicantNotificationsMailer, :notify_new_state) }
      end
    end
  end

  describe "files_to_be_provided" do
    before do
      create(
        :job_application_file_type,
        name: "CV", from_state: :initial, kind: :applicant_provided, by_default: true
      )
      create(
        :job_application_file_type,
        name: "LM", from_state: :initial, kind: :applicant_provided, by_default: true
      )
      create(
        :job_application_file_type,
        name: "FILE", from_state: :to_be_met, kind: :applicant_provided, by_default: true
      )
    end

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
    context "when job_offer published 20 days before" do
      before { job_offer.update(csp_date: 20.days.before) }

      it "cant be accepted" do
        expect { job_application.accepted! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when job_offer published 31 days before" do
      before { job_offer.update(csp_date: 31.days.before) }

      it "can be accepted" do
        expect(job_application.accepted!).to be(true)
      end
    end
  end

  describe "complete_files_before_draft_contract" do
    let(:job_application) { create(:job_application, state: :accepted) }
    let!(:jaft_1) do
      create(
        :job_application_file_type,
        name: "File 1", from_state: :accepted, kind: :applicant_provided, by_default: true
      )
    end
    let!(:jaft_2) do
      create(
        :job_application_file_type,
        name: "File 2", from_state: :to_be_met, kind: :applicant_provided, by_default: true
      )
    end

    before do
      create(
        :job_application_file_type,
        name: "File 3", from_state: :accepted, kind: :applicant_provided, by_default: false
      )
    end

    context "when no files are filled" do
      it "cant pass to contract_drafting" do
        expect { job_application.contract_drafting! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when files are fill but not validated" do
      before do
        create(
          :job_application_file,
          job_application: job_application, job_application_file_type: jaft_1
        )
        create(
          :job_application_file,
          job_application: job_application, job_application_file_type: jaft_2
        )
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

      it "cant pass to contract_drafting" do
        expect(job_application.contract_drafting!).to be(true)
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
#  preselection                      :integer          default("pending")
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
