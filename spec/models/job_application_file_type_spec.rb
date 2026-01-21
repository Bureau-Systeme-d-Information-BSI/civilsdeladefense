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
  end

  describe "scopes" do
    describe "#for_states_around" do
      subject { described_class.for_states_around(:accepted) }

      let!(:jaft_around) { create(:job_application_file_type, from_state: :to_be_met, to_state: :contract_drafting) }
      let!(:jaft_not_around) { create(:job_application_file_type, from_state: :contract_drafting, to_state: :affected) }

      it { is_expected.to match([jaft_around]) }
      it { is_expected.not_to include(jaft_not_around) }
    end

    describe "#required" do
      subject { described_class.required(:to_be_met) }

      let!(:jaft_required) do
        create(:job_application_file_type, required: true, required_from_state: :phone_meeting, required_to_state: :accepted)
      end
      let!(:jaft_not_around) do
        create(:job_application_file_type, required: true, required_from_state: :contract_drafting, required_to_state: :affected)
      end
      let!(:jaft_not_required) do
        create(:job_application_file_type, required: false, required_from_state: :phone_meeting, required_to_state: :accepted)
      end

      it { is_expected.to match([jaft_required]) }
      it { is_expected.not_to include(jaft_not_around) }
      it { is_expected.not_to include(jaft_not_required) }
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
