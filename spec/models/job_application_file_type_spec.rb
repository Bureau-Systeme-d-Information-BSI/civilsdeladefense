# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplicationFileType do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:from_state) }

    it { is_expected.to validate_presence_of(:to_state) }

    context "when required" do
      subject { build(:job_application_file_type, required: true) }

      it { is_expected.to validate_presence_of(:required_from_state) }
      it { is_expected.to validate_presence_of(:required_to_state) }
    end

    context "without an administrator visibility rule" do
      subject(:jaft) { build(:job_application_file_type) }

      before { jaft.visibility_rules.target.reject!(&:administrator?) }

      it { is_expected.not_to be_valid }
      it { expect(jaft.tap(&:valid?).errors[:visibility_rules]).to be_present }
    end

    context "without a user visibility rule" do
      subject(:jaft) { build(:job_application_file_type) }

      before { jaft.visibility_rules.target.reject!(&:user?) }

      it { is_expected.not_to be_valid }
      it { expect(jaft.tap(&:valid?).errors[:visibility_rules]).to be_present }
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

    describe "#required" do
      subject { described_class.required(:to_be_met) }

      let!(:jaft_required) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :to_be_met)
        end
      end
      let!(:jaft_last_state_after) do
        create(:job_application_file_type).tap do |jaft|
          jaft.visibility_rules.where(by: :administrator).destroy_all
          jaft.visibility_rules.create!(by: :administrator, state: :contract_drafting)
        end
      end

      it { is_expected.to include(jaft_required) }
      it { is_expected.not_to include(jaft_last_state_after) }
    end
  end
end

# == Schema Information
#
# Table name: job_application_file_types
#
#  id                  :uuid             not null, primary key
#  content_file_name   :string
#  description         :string
#  from_state          :integer
#  kind                :integer
#  name                :string
#  notification        :boolean          default(TRUE)
#  position            :integer
#  required            :boolean          default(FALSE), not null
#  required_from_state :integer          default(0)
#  required_to_state   :integer          default(11)
#  to_state            :integer          default("affected")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
