# frozen_string_literal: true

require "rails_helper"

RSpec.describe VisibilityRule do
  describe "associations" do
    it { is_expected.to belong_to(:job_application_file_type) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:by) }
    it { is_expected.to validate_presence_of(:state) }

    it "only allows administrator or user for by" do
      expect(described_class.bies.keys).to match_array(%w[administrator user])
    end

    it "uses the same states as JobApplication" do
      expect(described_class.states).to eq(JobApplication.states.transform_keys(&:to_s))
    end
  end

  describe "defaults" do
    subject(:rule) { described_class.new }

    it { expect(rule.by).to eq("administrator") }
    it { expect(rule.state).to eq("initial") }
  end
end

# == Schema Information
#
# Table name: visibility_rules
#
#  id                           :uuid             not null, primary key
#  by                           :string           default("administrator"), not null
#  state                        :integer          default("initial"), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  job_application_file_type_id :uuid             not null
#
# Indexes
#
#  index_visibility_rules_on_job_application_file_type_id  (job_application_file_type_id)
#
# Foreign Keys
#
#  fk_rails_2da155b95c  (job_application_file_type_id => job_application_file_types.id)
#
