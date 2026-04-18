# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdministratorPermissions do
  describe ".allows?" do
    subject(:allows?) { described_class.allows?(role:, state:, action:) }

    context "when the permission value is true" do
      let(:role) { :functional_administrator }
      let(:state) { :initial }
      let(:action) { :show_application }

      it { is_expected.to be(true) }
    end

    context "when the permission value is false" do
      let(:role) { :functional_administrator }
      let(:state) { :initial }
      let(:action) { :update_application_dar }

      it { is_expected.to be(false) }
    end

    context "when the permission value is a non-empty list" do
      let(:role) { :hr_manager }
      let(:state) { :contract_drafting }
      let(:action) { :update_application_state }

      it { is_expected.to be(true) }
    end

    context "when the role, state or action is passed as a string" do
      let(:role) { "employer_recruiter" }
      let(:state) { "accepted" }
      let(:action) { "update_application_rejected" }

      it { is_expected.to be(true) }
    end

    context "when the role is unknown" do
      let(:role) { :unknown_role }
      let(:state) { :initial }
      let(:action) { :show_application }

      it { is_expected.to be(false) }
    end

    context "when the state is unknown" do
      let(:role) { :functional_administrator }
      let(:state) { :unknown_state }
      let(:action) { :show_application }

      it { is_expected.to be(false) }
    end

    context "when the action is unknown" do
      let(:role) { :functional_administrator }
      let(:state) { :initial }
      let(:action) { :unknown_action }

      it { is_expected.to be(false) }
    end
  end

  describe ".allows_state_transition?" do
    subject(:allows_state_transition?) { described_class.allows_state_transition?(role:, state:, target_state:) }

    context "when the target state is in the allowed list" do
      let(:role) { :functional_administrator }
      let(:state) { :initial }
      let(:target_state) { :phone_meeting }

      it { is_expected.to be(true) }
    end

    context "when the target state is not in the allowed list" do
      let(:role) { :functional_administrator }
      let(:state) { :initial }
      let(:target_state) { :accepted }

      it { is_expected.to be(false) }
    end

    context "when no transition is allowed for the state" do
      let(:role) { :hr_manager }
      let(:state) { :initial }
      let(:target_state) { :phone_meeting }

      it { is_expected.to be(false) }
    end

    context "when the role, state or target_state are passed as a string" do
      let(:role) { "hr_manager" }
      let(:state) { "contract_drafting" }
      let(:target_state) { "contract_feedback_waiting" }

      it { is_expected.to be(true) }
    end
  end
end
