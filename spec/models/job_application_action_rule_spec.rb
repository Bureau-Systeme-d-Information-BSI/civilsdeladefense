# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplicationActionRule do
  describe "validations" do
    subject(:model) { build(:job_application_action_rule) }

    it { is_expected.to validate_presence_of(:role) }

    it { is_expected.to validate_presence_of(:state) }

    it "validates uniqueness of role scoped to state" do
      create(:job_application_action_rule)
      expect(model).not_to be_valid
      expect(model.errors[:role]).to be_present
    end

    context "when manage_state is true" do
      subject(:model) { build(:job_application_action_rule, manage_state: true, to_state: nil) }

      it { is_expected.not_to be_valid }

      it "requires to_state" do
        model.valid?
        expect(model.errors[:to_state]).to be_present
      end
    end

    context "when manage_state is false" do
      subject(:model) { build(:job_application_action_rule, manage_state: false, to_state: nil) }

      it { is_expected.to be_valid }
    end
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:role) }

    it { is_expected.to define_enum_for(:state) }

    it { is_expected.to define_enum_for(:to_state).with_prefix }
  end
end

# == Schema Information
#
# Table name: job_application_action_rules
#
#  id               :uuid             not null, primary key
#  comment          :boolean          default(FALSE), not null
#  manage_file      :boolean          default(FALSE), not null
#  manage_state     :boolean          default(FALSE), not null
#  manage_user_info :boolean          default(FALSE), not null
#  read             :boolean          default(FALSE), not null
#  reject           :boolean          default(FALSE), not null
#  role             :integer          not null
#  send_email       :boolean          default(FALSE), not null
#  state            :integer          not null
#  to_state         :integer
#  validate_dar     :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_job_application_action_rules_on_role_and_state  (role,state) UNIQUE
#
