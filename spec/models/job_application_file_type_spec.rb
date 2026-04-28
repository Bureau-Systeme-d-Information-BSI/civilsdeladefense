# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplicationFileType do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    context "without an administrator visibility rule" do
      subject(:jaft) { build(:job_application_file_type) }

      before { jaft.visibility_rules.target.reject!(&:administrator?) }

      it { is_expected.not_to be_valid }
      it { expect(jaft.tap(&:valid?).errors[:visibility_rules]).to be_present }
    end

    context "without any validator" do
      subject(:jaft) do
        build(:job_application_file_type,
          validate_by_employer_recruiter: false,
          validate_by_employment_authority: false,
          validate_by_hr_manager: false,
          validate_by_payroll_manager: false)
      end

      it { is_expected.not_to be_valid }
      it { expect(jaft.tap(&:valid?).errors[:base]).to be_present }
    end

    context "with at least one validator" do
      subject(:jaft) { build(:job_application_file_type, validate_by_hr_manager: true) }

      it { is_expected.to be_valid }
    end

    context "without a user visibility rule" do
      subject(:jaft) { build(:job_application_file_type) }

      before { jaft.visibility_rules.target.reject!(&:user?) }

      it { is_expected.not_to be_valid }
      it { expect(jaft.tap(&:valid?).errors[:visibility_rules]).to be_present }
    end
  end

  describe "#can_validate?" do
    subject { file_type.can_validate?(administrator) }

    let(:file_type) do
      build(:job_application_file_type,
        validate_by_employer_recruiter: true,
        validate_by_hr_manager: true,
        validate_by_employment_authority: false,
        validate_by_payroll_manager: false)
    end

    context "when administrator has a matching role" do
      let(:administrator) { build(:administrator, roles: [:employer_recruiter]) }

      it { is_expected.to be(true) }
    end

    context "when administrator has another matching role" do
      let(:administrator) { build(:administrator, roles: [:hr_manager]) }

      it { is_expected.to be(true) }
    end

    context "when administrator has no matching role" do
      let(:administrator) { build(:administrator, roles: [:payroll_manager]) }

      it { is_expected.to be(false) }
    end

    context "when administrator is a functional_administrator" do
      let(:administrator) { build(:administrator, roles: [:functional_administrator]) }

      it { is_expected.to be(true) }
    end
  end

  describe "scopes" do
    describe "#visible_by_user" do
      subject { described_class.visible_by_user(:phone_meeting) }

      let!(:jaft_visible) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.create!(by: :user, state: :phone_meeting)
        end
      end
      let!(:jaft_not_visible) { create(:job_application_file_type) }
      let!(:jaft_admin_only) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.create!(by: :administrator, state: :phone_meeting)
        end
      end

      it { is_expected.to include(jaft_visible) }
      it { is_expected.not_to include(jaft_not_visible) }
      it { is_expected.not_to include(jaft_admin_only) }
    end

    describe "#visible_by_user_up_to" do
      subject { described_class.visible_by_user_up_to(:to_be_met) }

      let!(:jaft_before) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.create!(by: :user, state: :phone_meeting)
        end
      end
      let!(:jaft_exact) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.create!(by: :user, state: :to_be_met)
        end
      end
      let!(:jaft_after) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.where(by: :user).destroy_all
          jaft.visibility_rules.create!(by: :user, state: :financial_estimate)
        end
      end

      let!(:jaft_admin_only_before) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.where(by: :user).destroy_all
          jaft.visibility_rules.create!(by: :user, state: :financial_estimate)
          jaft.visibility_rules.create!(by: :administrator, state: :phone_meeting)
        end
      end

      it { is_expected.to include(jaft_before) }
      it { is_expected.to include(jaft_exact) }
      it { is_expected.not_to include(jaft_after) }
      it { is_expected.not_to include(jaft_admin_only_before) }
    end

    describe "#notifiable_by_user_at" do
      subject { described_class.notifiable_by_user_at(:to_be_met) }

      let!(:jaft_matching) do
        create(:job_application_file_type, notify_user: true).tap do |jaft|
          jaft.visibility_rules.create!(by: :user, state: :to_be_met)
        end
      end
      let!(:jaft_wrong_state) do
        create(:job_application_file_type, notify_user: true).tap do |jaft|
          jaft.visibility_rules.where(by: :user).destroy_all
          jaft.visibility_rules.create!(by: :user, state: :phone_meeting)
        end
      end
      let!(:jaft_not_notifiable) do
        create(:job_application_file_type, notify_user: false).tap do |jaft|
          jaft.visibility_rules.create!(by: :user, state: :to_be_met)
        end
      end

      it { is_expected.to include(jaft_matching) }
      it { is_expected.not_to include(jaft_wrong_state) }
      it { is_expected.not_to include(jaft_not_notifiable) }
    end

    describe "#visible_by_administrator" do
      subject { described_class.visible_by_administrator(:to_be_met) }

      let!(:jaft_before) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :phone_meeting)
        end
      end
      let!(:jaft_exact) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :to_be_met)
        end
      end
      let!(:jaft_after) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :contract_drafting)
        end
      end

      it { is_expected.to include(jaft_before) }
      it { is_expected.to include(jaft_exact) }
      it { is_expected.not_to include(jaft_after) }
    end

    describe "#required" do
      subject { described_class.required(:to_be_met) }

      let!(:jaft_required) do
        create(:job_application_file_type, required: true).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :to_be_met)
        end
      end
      let!(:jaft_last_state_after) do
        create(:job_application_file_type, required: true).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :contract_drafting)
        end
      end
      let!(:jaft_not_required) do
        create(:job_application_file_type, required: false).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :to_be_met)
        end
      end

      let!(:jaft_with_rules_before_and_after) do
        create(:job_application_file_type, required: true).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :initial)
          jaft.visibility_rules.create!(by: :administrator, state: :contract_drafting)
        end
      end

      it { is_expected.to include(jaft_required) }
      it { is_expected.to include(jaft_with_rules_before_and_after) }
      it { is_expected.not_to include(jaft_last_state_after) }
      it { is_expected.not_to include(jaft_not_required) }
    end

    describe "#mandatory" do
      subject { described_class.mandatory(:financial_estimate) }

      let!(:jaft_required_visible_before) do
        create(:job_application_file_type, required: true).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :to_be_met)
        end
      end
      let!(:jaft_required_visible_after) do
        create(:job_application_file_type, required: true).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :accepted)
        end
      end
      let!(:jaft_non_required_past_visibility) do
        create(:job_application_file_type, required: false).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :to_be_met)
        end
      end
      let!(:jaft_non_required_still_visible) do
        create(:job_application_file_type, required: false).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :financial_estimate)
        end
      end
      let!(:jaft_non_required_visible_after) do
        create(:job_application_file_type, required: false).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :accepted)
        end
      end

      it { is_expected.to include(jaft_required_visible_before) }
      it { is_expected.not_to include(jaft_required_visible_after) }
      it { is_expected.to include(jaft_non_required_past_visibility) }
      it { is_expected.not_to include(jaft_non_required_still_visible) }
      it { is_expected.not_to include(jaft_non_required_visible_after) }
    end
  end
end

# == Schema Information
#
# Table name: job_application_file_types
#
#  id                               :uuid             not null, primary key
#  content_file_name                :string
#  description                      :string
#  kind                             :integer
#  name                             :string
#  notification                     :boolean          default(TRUE)
#  notify_employer_recruiter        :boolean          default(FALSE), not null
#  notify_employment_authority      :boolean          default(FALSE), not null
#  notify_hr_manager                :boolean          default(FALSE), not null
#  notify_payroll_manager           :boolean          default(FALSE), not null
#  notify_user                      :boolean          default(FALSE), not null
#  position                         :integer
#  required                         :boolean          default(FALSE), not null
#  validate_by_employer_recruiter   :boolean          default(FALSE), not null
#  validate_by_employment_authority :boolean          default(FALSE), not null
#  validate_by_hr_manager           :boolean          default(FALSE), not null
#  validate_by_payroll_manager      :boolean          default(FALSE), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
