# frozen_string_literal: false

require "rails_helper"

RSpec.describe JobApplication do
  let(:job_offer) { create(:job_offer) }
  let(:job_application) { create(:job_application, job_offer:) }

  describe "delegations" do
    it { is_expected.to delegate_method(:employer_recruiters).to(:job_offer).with_prefix(true) }

    it { is_expected.to delegate_method(:employment_authorities).to(:job_offer).with_prefix(true) }

    it { is_expected.to delegate_method(:hr_managers).to(:job_offer).with_prefix(true) }

    it { is_expected.to delegate_method(:payroll_managers).to(:job_offer).with_prefix(true) }
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

      context "when the job offer has initial but rejected job applications" do
        before { create(:job_application, :rejected, job_offer:, state: :initial) }

        it { is_expected.to be(true) }
      end
    end

    describe "#dar_validated" do
      subject(:contract_drafting) { job_application.contract_drafting! }

      let(:job_application) { create(:job_application, state: :accepted, dar:) }

      context "when the dar is validated" do
        let(:dar) { true }

        it { is_expected.to be(true) }
      end

      context "when the dar is not validated" do
        let(:dar) { false }

        it { expect { contract_drafting }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end

  describe "scopes" do
    describe ".not_rejected" do
      subject { described_class.not_rejected }

      let(:matching) { create(:job_application, rejected: false) }
      let(:unmatching) { create(:job_application, :rejected) }

      it { is_expected.to include(matching) }

      it { is_expected.not_to include(unmatching) }
    end

    describe ".with_category" do
      subject { described_class.with_category }

      let(:matching) { create(:job_application, category: create(:category)) }
      let(:unmatching) { create(:job_application, category: nil) }

      it { is_expected.to include(matching) }

      it { is_expected.not_to include(unmatching) }
    end
  end

  describe "#file_types_for_user" do
    subject(:file_types_for_user) { job_application.file_types_for_user }

    let(:job_application) { create(:job_application, job_offer:, state: :phone_meeting) }
    let!(:visible_type) do
      create(:job_application_file_type).tap do |jaft|
        jaft.visibility_rules.where(by: :user).destroy_all
        jaft.visibility_rules.create!(by: :user, state: :phone_meeting)
      end
    end
    let!(:hidden_type) do
      create(:job_application_file_type).tap do |jaft|
        jaft.visibility_rules.where(by: :user).destroy_all
        jaft.visibility_rules.create!(by: :user, state: :financial_estimate)
      end
    end
    let!(:already_uploaded_hidden_type) do
      create(:job_application_file_type).tap do |jaft|
        jaft.visibility_rules.where(by: :user).destroy_all
        jaft.visibility_rules.create!(by: :user, state: :financial_estimate)
      end
    end

    before do
      create(:job_application_file, job_application:, job_application_file_type: already_uploaded_hidden_type)
      job_application.reload
    end

    it { is_expected.to include(visible_type) }

    it { is_expected.to include(already_uploaded_hidden_type) }

    it { is_expected.not_to include(hidden_type) }

    it "returns each type only once" do
      create(:job_application_file, job_application:, job_application_file_type: visible_type)
      job_application.reload
      expect(file_types_for_user.count(visible_type)).to eq(1)
    end

    it "ignores placeholder files without uploaded content" do
      empty_type = create(:job_application_file_type).tap do |jaft|
        jaft.visibility_rules.where(by: :user).destroy_all
        jaft.visibility_rules.create!(by: :user, state: :financial_estimate)
      end
      create(:job_application_file, job_application:, job_application_file_type: empty_type, content: nil, do_not_provide_immediately: true)
      job_application.reload
      expect(file_types_for_user).not_to include(empty_type)
    end
  end

  describe "#file_for" do
    subject(:file_for) { job_application.file_for(type) }

    let(:job_application) { create(:job_application) }
    let(:type) { create(:job_application_file_type) }

    context "when a file already exists for the type" do
      let!(:existing_file) { create(:job_application_file, job_application:, job_application_file_type: type) }

      before { job_application.reload }

      it { is_expected.to eq(existing_file) }
    end

    context "when no file exists for the type" do
      it "builds a new unsaved file with the given type" do
        expect(file_for).to be_new_record
        expect(file_for.job_application_file_type).to eq(type)
      end
    end
  end

  describe "#create_required_job_application_files" do
    let(:job_application) { create(:job_application, job_offer:, state: :phone_meeting) }
    let!(:required_file_type) do
      create(:job_application_file_type, required: true).tap do |jaft|
        jaft.visibility_rules.where(by: :administrator).destroy_all
        jaft.visibility_rules.create!(by: :administrator, state: :to_be_met)
      end
    end
    let!(:not_yet_required_file_type) do
      create(:job_application_file_type, required: true).tap do |jaft|
        jaft.visibility_rules.where(by: :administrator).destroy_all
        jaft.visibility_rules.create!(by: :administrator, state: :contract_drafting)
      end
    end

    context "when state moves forward" do
      before do
        JobApplicationFileType.mandatory(:phone_meeting).find_each do |jaft|
          file = job_application.job_application_files.find_by(job_application_file_type: jaft) ||
            create(:job_application_file, job_application:, job_application_file_type: jaft)
          file.update_column(:is_validated, 1) # rubocop:disable Rails/SkipsModelValidations
        end
        job_application.reload
      end

      it "creates job application files for newly required file types" do
        expect { job_application.to_be_met! }.to change { job_application.job_application_files.count }.by(1)
        expect(job_application.job_application_files.map(&:job_application_file_type)).to include(required_file_type)
        expect(job_application.job_application_files.map(&:job_application_file_type)).not_to include(not_yet_required_file_type)
      end
    end

    context "when the file type is already requested" do
      before do
        create(:job_application_file, job_application:, job_application_file_type: required_file_type)
        job_application.job_application_files.reload.each { |f| f.update_column(:is_validated, 1) } # rubocop:disable Rails/SkipsModelValidations
      end

      it "does not create a duplicate" do
        expect { job_application.to_be_met! }.not_to change { job_application.job_application_files.count }
      end
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
end

# == Schema Information
#
# Table name: job_applications
#
#  id                                :uuid             not null, primary key
#  administrator_notifications_count :integer          default(0)
#  dar                               :boolean          default(FALSE), not null
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
