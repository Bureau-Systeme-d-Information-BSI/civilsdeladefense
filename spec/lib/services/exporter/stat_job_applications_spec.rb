# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exporter::StatJobApplications do
  let(:user) { create(:administrator) }

  describe "#generate" do
    subject(:generate) { described_class.new(data, user).generate }

    context "with populated statistics" do
      let(:data) do
        employer = create(:employer)
        category = create(:category)
        bop = create(:bop)
        department = create(:department)
        rejection_reason = create(:rejection_reason)
        age_range = AgeRange.first
        {
          job_applications_count: 4,
          date_start: Date.new(2026, 1, 1),
          date_end: Date.new(2026, 6, 1),
          per_state: {"selected" => 2, "affected" => 1, "phone_meeting" => 1},
          per_rejection_reason: {rejection_reason.id => 3, "unknown" => 1},
          rejection_reasons: [rejection_reason],
          per_gender: {2 => 2, nil => 1},
          per_age_range: {age_range.id => 2, nil => 1},
          age_ranges: [age_range],
          per_experiences_fit_job_offer: {true => 2},
          per_has_corporate_experience: {true => 1},
          per_is_currently_employed: {true => 1},
          state_duration: [["to_be_processed", "selected", 3.5]],
          q: {
            employer_id_in: [employer.id],
            job_offer_category_id_in: [category.id],
            contract_type_id_in: [ContractType.first.id],
            job_offer_bop_id_in: [bop.id],
            profile_experience_level_id_in: [ExperienceLevel.first.id],
            profile_study_level_id_in: [StudyLevel.first.id],
            profile_departments_id_in: [department.id]
          }
        }
      end

      it { is_expected.to be_a(StringIO) }
    end

    context "with empty statistics" do
      let(:data) do
        {
          job_applications_count: 0,
          date_start: Date.new(2026, 1, 1),
          date_end: Date.new(2026, 6, 1),
          per_state: {},
          per_rejection_reason: {},
          rejection_reasons: [],
          per_gender: {},
          per_age_range: {},
          age_ranges: [],
          per_experiences_fit_job_offer: {},
          per_has_corporate_experience: {},
          per_is_currently_employed: {},
          state_duration: [],
          q: {}
        }
      end

      it { is_expected.to be_a(StringIO) }
    end
  end

  describe "#stat_data" do
    subject(:stat_data) { described_class.new(data, user).stat_data }

    let(:data) { {job_applications_count: 0} }

    it { is_expected.to eq(data) }
  end
end
